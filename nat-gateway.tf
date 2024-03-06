resource "aws_nat_gateway" "ngw" {
  for_each = toset(var.availability_zones)

  allocation_id = aws_eip.ngw_eip[each.key].id
  subnet_id     = aws_subnet.ngw_subnet[each.key].id

  tags = {
    "Availability Zone"    = each.key
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway-${each.key}"
  }
}

resource "aws_eip" "ngw_eip" {
  for_each = toset(var.availability_zones)

  domain = "vpc"

  tags = {
    "Availability Zone"    = each.key
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway-${each.key}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "ngw_subnet" {
  for_each = {
    for az in sort(var.availability_zones) : az => {
      az   = az
      name = "${var.name}-nat-gateway-${az}"
      cidr_block = cidrsubnet(
        var.cidr_block,
        coalesce(var.nat_gateway_subnets.newbits, 28 - parseint(split("/", var.cidr_block)[1], 10)),
        coalesce(var.nat_gateway_subnets.first_netnum, 0) + index(sort(var.availability_zones), az)
      )
    }
  }

  availability_zone = each.value.az
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.vpc.id

  tags = {
    "Availability Zone"    = each.value.az
    "Managed By Terraform" = "true"
    "Name"                 = each.value.name
    "Type"                 = "public"
  }
}

resource "aws_route_table" "ngw_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway"
    "Type"                 = "public"
  }
}

resource "aws_route_table_association" "ngw" {
  for_each = toset(var.availability_zones)

  route_table_id = aws_route_table.ngw_route_table.id
  subnet_id      = aws_subnet.ngw_subnet[each.key].id
}

resource "aws_network_acl" "ngw_nacl" {
  subnet_ids = [for az in var.availability_zones : aws_subnet.ngw_subnet[az].id]
  vpc_id     = aws_vpc.vpc.id

  tags = {
    "Availability Zones"   = join(",", sort(var.availability_zones))
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway"
    "Type"                 = "public"
  }
}

resource "aws_network_acl_rule" "ngw_ephemeral_ingress" {
  cidr_block     = "0.0.0.0/0"
  egress         = false
  from_port      = 1024
  network_acl_id = aws_network_acl.ngw_nacl.id
  protocol       = "tcp"
  rule_action    = "allow"
  rule_number    = 1
  to_port        = 65535
}

resource "aws_network_acl_rule" "ngw_egress" {
  cidr_block     = "0.0.0.0/0"
  egress         = true
  from_port      = 0
  network_acl_id = aws_network_acl.ngw_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 1
  to_port        = 0
}

resource "aws_network_acl_rule" "ngw_subnet_ingress" {
  for_each = {
    for ingress in flatten([
      for group in var.subnet_groups : [
        for az in var.availability_zones : {
          az         = az
          group_name = group.name
        }
      ] if group.type == "private"
    ]) : "${ingress.group_name}-${ingress.az}" => ingress
  }

  rule_action    = "allow"
  cidr_block     = aws_subnet.subnet["${each.value.group_name}-${each.value.az}"].cidr_block
  from_port      = 0
  network_acl_id = aws_network_acl.ngw_nacl.id
  protocol       = "-1"
  rule_number = (
    index(sort(var.availability_zones), each.value.az) +
    (10 * (1 + index(sort(var.subnet_groups[*].name), each.value.group_name)))
  )
  to_port = 0
}
