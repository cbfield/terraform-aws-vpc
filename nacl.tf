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
      for group in var.subnet_groups : concat(
        [
          for ingress in coalesce(group.nacl.ingress, []) : ingress.subnet_group != null ? [
            for az in var.availability_zones : merge(ingress, {
              az         = az
              egress     = false
              group_name = group.name
              rule_no    = ingress.rule_no + index(sort(var.availability_zones), az)
            })
            ] : [merge(ingress, {
              egress     = false
              group_name = group.name
          })]
        ],
        [
          for egress in coalesce(group.nacl.egress, []) : egress.subnet_group != null ? [
            for az in var.availability_zones : merge(egress, {
              az         = az
              egress     = true
              group_name = group.name
              rule_no    = egress.rule_no + index(sort(var.availability_zones), az)
            })
            ] : [merge(egress, {
              egress     = true
              group_name = group.name
          })]
        ]
      ) if group.nacl != null
    ]) : "${rule.group_name}-${rule.egress ? "egress" : "ingress"}-${rule.rule_no}" => rule
  }

  cidr_block = each.value.subnet_group != null ? (
    aws_subnet.subnet["${each.value.subnet_group}-${each.value.az}"].cidr_block
  ) : each.value.cidr_block
  egress          = each.value.egress
  from_port       = each.value.from_port
  ipv6_cidr_block = each.value.ipv6_cidr_block
  network_acl_id  = aws_network_acl.nacl[each.value.group_name].id
  protocol        = each.value.protocol
  rule_action     = each.value.action
  rule_number     = each.value.rule_no
  to_port         = each.value.to_port
}
