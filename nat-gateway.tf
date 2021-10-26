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

  vpc = true

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
        28 - parseint(split("/", var.cidr_block)[1], 10),
        index(sort(var.availability_zones), az)
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

  dynamic "ingress" {
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

    content {
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      action     = "allow"
      cidr_block = aws_subnet.subnet["${ingress.value.group_name}-${ingress.value.az}"].cidr_block

      rule_no = (
        (1 + index(sort(var.availability_zones), ingress.value.az)) +
        (10 * (1 + index(sort(var.subnet_groups[*].name), ingress.value.group_name)))
      )
    }
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    rule_no    = 1
  }

  tags = {
    "Availability Zones"   = join(",", sort(var.availability_zones))
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway"
    "Type"                 = "public"
  }
}
