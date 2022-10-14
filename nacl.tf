resource "aws_network_acl" "nacl" {
  for_each = { for group in var.subnet_groups : group.name => group }

  subnet_ids = [for az in var.availability_zones : aws_subnet.subnet["${each.value.name}-${az}"].id]
  vpc_id     = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-${each.value.name}"
    "Type"                 = each.value.type
  })
}

resource "aws_network_acl_rule" "rule" {
  for_each = {
    for rule in flatten([
      for group in var.subnet_groups : [
        for rule in coalesce(group.nacl, []) : merge(rule, { group_name = group.name }) if rule.subnet_group == null
      ]
    ]) : "${rule.group_name}-${rule.egress ? "egress" : "ingress"}-${rule.rule_no}" => rule
  }

  cidr_block      = each.value.cidr_block
  egress          = each.value.egress
  from_port       = each.value.from_port
  ipv6_cidr_block = each.value.ipv6_cidr_block
  network_acl_id  = aws_network_acl.nacl[each.value.group_name].id
  protocol        = each.value.protocol
  rule_action     = each.value.action
  rule_number     = each.value.rule_no
  to_port         = each.value.to_port
}

resource "aws_network_acl_rule" "rule_by_group" {
  for_each = {
    for rule in flatten([
      for group in var.subnet_groups : [
        for rule in coalesce(group.nacl, []) : [
          for az in var.availability_zones : merge(rule, {
            az         = az
            group_name = group.name
            rule_no    = rule.rule_no + index(sort(var.availability_zones), az)
          })
        ] if rule.subnet_group != null
      ]
    ]) : "${rule.group_name}-${rule.egress ? "egress" : "ingress"}-${rule.rule_no}" => rule
  }

  cidr_block      = aws_subnet.subnet["${each.value.subnet_group}-${each.value.az}"].cidr_block
  egress          = each.value.egress
  from_port       = each.value.from_port
  ipv6_cidr_block = each.value.ipv6_cidr_block
  network_acl_id  = aws_network_acl.nacl[each.value.group_name].id
  protocol        = each.value.protocol
  rule_action     = each.value.action
  rule_number     = each.value.rule_no
  to_port         = each.value.to_port
}
