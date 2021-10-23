resource "aws_network_acl" "ngw_nacl" {
  subnet_ids = [for az in local.zones : aws_subnet.ngw_subnet[az].id]
  vpc_id     = aws_vpc.vpc.id

  tags = {
    "Availability Zones"   = join(",", local.zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway"
    "Type"                 = "public"
  }
}

resource "aws_network_acl_rule" "ngw_ingress" {
  for_each = { for ingress in flatten([
    for group in var.subnet_groups : [
      for az in group.availability_zones : {
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
  rule_number    = 1 + index(local.zones, each.value.az) + (10 * (1 + index(local.subnet_groups, each.value.group_name)))
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

  subnet_ids = [for az in each.value.availability_zones : aws_subnet.subnet["${each.value.name}-${az}"].id]
  vpc_id     = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Availability Zones"   = join(",", each.value.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = each.value.name
    "Type"                 = each.value.type
  })
}

resource "aws_network_acl_rule" "self_ingress" {
  for_each = {
    for ingress in flatten([
      for group in var.subnet_groups : [
        for az in group.availability_zones : {
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
  rule_number    = 1 + index(local.zones, each.value.availability_zone)
  to_port        = 0
}

resource "aws_network_acl_rule" "private_ingress" {
  for_each = {
    for ingress in flatten([
      for private_group in var.subnet_groups : [
        for public_group in var.subnet_groups : [
          for az in public_group.availability_zones : {
            az                 = az
            private_group_name = private_group.name
            public_group_name  = public_group.name
            cidr_block         = aws_subnet.subnet["${public_group.name}-${az}"].cidr_block
          }
        ] if public_group.type == "public"
      ] if private_group.type == "private"
    ]) : "${ingress.public_group_name}-${ingress.cidr_block}" => ingress
  }

  cidr_block     = each.value.cidr_block
  egress         = false
  from_port      = 0
  network_acl_id = aws_network_acl.nacl[each.value.private_group_name].id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 1 + index(local.zones, each.value.az) + (10 * (1 + index(local.subnet_groups, each.value.public_group_name)))
  to_port        = 0
}

resource "aws_network_acl_rule" "persistence_ingress" {
  for_each = {
    for ingress in flatten([
      for persistence_group in var.subnet_groups : [
        for private_group in var.subnet_groups : [
          for az in private_group.availability_zones : {
            az                     = az
            persistence_group_name = persistence_group.name
            private_group_name     = private_group.name
            cidr_block             = aws_subnet.subnet["${private_group.name}-${az}"].cidr_block
          }
        ] if private_group.type == "private"
      ] if persistence_group.type == "persistence"
    ]) : "${ingress.private_group_name}-${ingress.cidr_block}" => ingress
  }

  cidr_block     = each.value.cidr_block
  egress         = false
  from_port      = 0
  network_acl_id = aws_network_acl.nacl[each.value.persistence_group_name].id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 1 + index(local.zones, each.value.az) + (10 * (1 + index(local.subnet_groups, each.value.private_group_name)))
  to_port        = 0
}
