resource "aws_network_acl" "ngw_nacl" {
  subnet_ids = [for az in var.availability_zones : aws_subnet.ngw_subnet[az].id]
  vpc_id     = aws_vpc.vpc.id

  tags = {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway"
    "Type"                 = "public"
  }
}

resource "aws_network_acl_rule" "ngw_ingress" {
  for_each = { for ingress in flatten([
    for group in var.subnet_groups : [
      for az in var.availability_zones : {
        az         = az
        cidr_block = aws_subnet.subnet["${group.name}-${az}"].cidr_block
        group_name = group.name
      }
    ] if group.type == "private"
    ]) : ingress.cidr_block => ingress
  }

  cidr_block     = each.value.cidr_block
  egress         = false
  from_port      = 0
  network_acl_id = aws_network_acl.ngw_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 1 + index(var.availability_zones, each.value.az) + (10 * (1 + index(local.subnet_groups, each.value.group_name)))
  to_port        = 0
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

resource "aws_network_acl" "nacl" {
  for_each = { for group in var.subnet_groups : group.name => group }

  subnet_ids = [for az in var.availability_zones : aws_subnet.subnet["${each.value.name}-${az}"].id]
  vpc_id     = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = each.value.name
    "Type"                 = each.value.type
  })
}

resource "aws_network_acl_rule" "self_ingress" {
  for_each = {
    for ingress in flatten([
      for group in var.subnet_groups : [
        for az in var.availability_zones : {
          availability_zone = az
          cidr_block        = aws_subnet.subnet["${group.name}-${az}"].cidr_block
          group_name        = group.name
        }
      ] if group.type != "persistence"
    ]) : "${ingress.group_name}-${ingress.cidr_block}" => ingress
  }

  cidr_block     = each.value.cidr_block
  egress         = false
  from_port      = 0
  network_acl_id = aws_network_acl.nacl[each.value.group_name].id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 1 + index(var.availability_zones, each.value.availability_zone)
  to_port        = 0
}

# TODO NACL rules given by arguments
