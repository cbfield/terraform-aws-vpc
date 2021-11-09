resource "aws_ec2_transit_gateway_vpc_attachment" "attachment" {
  for_each = { for attachment in var.transit_gateway_attachments : attachment.transit_gateway_id => attachment }

  appliance_mode_support                          = each.value.appliance_mode_support
  dns_support                                     = each.value.dns_support
  ipv6_support                                    = each.value.ipv6_support
  subnet_ids                                      = [for subnet in aws_subnet.tgw_subnet : subnet.id]
  transit_gateway_id                              = each.value.transit_gateway_id
  transit_gateway_default_route_table_association = each.value.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = each.value.transit_gateway_default_route_table_propagation
  vpc_id                                          = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Managed By Terraform" = "true"
  })
}

resource "aws_subnet" "tgw_subnet" {
  for_each = {
    for az in toset(var.availability_zones) : az => {
      az   = az
      name = "${var.name}-transit-gateway-${az}"
      cidr_block = cidrsubnet(
        var.cidr_block,
        coalesce(var.transit_gateway_subnets.newbits, 28 - parseint(split("/", var.cidr_block)[1], 10)),
        coalesce(var.transit_gateway_subnets.first_netnum, length(var.availability_zones)) + index(sort(var.availability_zones), az)
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

resource "aws_route_table" "tgw_route_table" {
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = {
      for rule in distinct(flatten([
        for group in var.subnet_groups : [
          for route in group.routes : route if route.transit_gateway_id != null
        ] if group.routes != null
      ])) : "${coalesce(rule.cidr_block, rule.prefix_list_id, rule.ipv6_cidr_block)}-${rule.transit_gateway_id}" => rule
    }

    content {
      cidr_block                 = route.value.cidr_block
      destination_prefix_list_id = route.value.prefix_list_id
      ipv6_cidr_block            = route.value.ipv6_cidr_block
      transit_gateway_id         = route.value.transit_gateway_id
    }
  }

  tags = {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-transit-gateway"
    "Type"                 = "airgapped"
  }
}

resource "aws_route_table_association" "tgw" {
  for_each = toset(var.availability_zones)

  route_table_id = aws_route_table.tgw_route_table.id
  subnet_id      = aws_subnet.tgw_subnet[each.key].id
}

resource "aws_network_acl" "tgw_nacl" {
  subnet_ids = [for az in var.availability_zones : aws_subnet.tgw_subnet[az].id]
  vpc_id     = aws_vpc.vpc.id

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.cidr_block
    rule_no    = 1
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
    "Name"                 = "${var.name}-transit-gateway"
    "Type"                 = "airgapped"
  }
}
