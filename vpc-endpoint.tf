resource "aws_vpc_endpoint" "endpoint" {
  for_each = { for endpoint in var.vpc_endpoints : endpoint.service_name => endpoint }

  auto_accept         = each.value.auto_accept
  policy              = each.value.policy
  private_dns_enabled = each.value.private_dns_enabled
  route_table_ids = each.value.vpc_endpoint_type == "Gateway" ? flatten([
    for table in each.value.route_tables : try(
      [aws_route_table.route_table[table.subnet_group].id],
      [for az in try(each.value.azs, var.availability_zones) : aws_route_table.route_table["${table.subnet_group}-${az}"].id]
    )
  ]) : null
  security_group_ids = each.value.vpc_endpoint_type == "Interface" ? [aws_security_group.endpoint.id] : null
  service_name       = each.value.service_name

  subnet_ids = each.value.vpc_endpoint_type == "Interface" || each.value.vpc_endpoint_type == "GatewayLoadBalancer" ? (
    [for net in aws_subnet.endpoint_subnet : net.id]
  ) : null

  vpc_endpoint_type = each.value.vpc_endpoint_type
  vpc_id            = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Managed By Terraform" = "true"
  })
}

resource "aws_subnet" "endpoint_subnet" {
  for_each = {
    for az in toset(var.availability_zones) : az => {
      az   = az
      name = "${var.name}-endpoint-${az}"
      cidr_block = cidrsubnet(
        var.cidr_block,
        coalesce(var.vpc_endpoint_subnets.newbits, 27 - parseint(split("/", var.cidr_block)[1], 10)),
        coalesce(var.vpc_endpoint_subnets.first_netnum, length(var.availability_zones)) + index(sort(var.availability_zones), az)
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
    "Type"                 = "airgapped"
  }
}

resource "aws_route_table" "endpoint_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-endpoint"
    "Type"                 = "airgapped"
  }
}

resource "aws_route_table_association" "endpoint" {
  for_each = toset(var.availability_zones)

  route_table_id = aws_route_table.endpoint_route_table.id
  subnet_id      = aws_subnet.endpoint_subnet[each.key].id
}

resource "aws_network_acl" "endpoint_nacl" {
  subnet_ids = [for az in var.availability_zones : aws_subnet.endpoint_subnet[az].id]
  vpc_id     = aws_vpc.vpc.id

  ingress {
    from_port  = 0
    to_port    = 65535
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.cidr_block
    rule_no    = 1
  }

  ingress {
    from_port  = 1024
    to_port    = 65535
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    rule_no    = 2
  }

  egress {
    from_port  = 0
    to_port    = 65535
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    rule_no    = 1
  }

  tags = {
    "Availability Zones"   = join(",", sort(var.availability_zones))
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-endpoint"
    "Type"                 = "airgapped"
  }
}

resource "aws_security_group" "endpoint" {
  description = "Manages ingress and egress for VPC endpoints in VPC ${var.name}"
  name        = "${var.name}-endpoint"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    "Managed By Terraform" = "true"
  }
}

resource "aws_security_group_rule" "endpoint_ingress" {
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.endpoint.id
  type              = "ingress"
}

resource "aws_security_group_rule" "endpoint_egress" {
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.endpoint.id
  type              = "egress"
}
