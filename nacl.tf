resource "aws_network_acl" "nacl" {
  for_each = { for group in var.subnet_groups : group.name => group }

  subnet_ids = [for az in var.availability_zones : aws_subnet.subnet["${each.value.name}-${az}"].id]
  vpc_id     = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = try(each.value.nacl.self_ingress, false) ? toset(var.availability_zones) : toset([])

    content {
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      action     = "allow"
      cidr_block = aws_subnet.subnet["${each.value.name}-${ingress.key}"].cidr_block
      rule_no    = 1 + index(sort(var.availability_zones), ingress.key)
    }
  }

  dynamic "ingress" {
    for_each = try(
      { for ingress in each.value.ingress : coalesce(ingress.cidr_block, ingress.ipv6_cidr_block) => ingress },
      {}
    )

    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      action          = ingress.value.action
      cidr_block      = ingress.value.cidr_block
      ipv6_cidr_block = ingress.value.ipv6_cidr_block
      rule_no         = ingress.value.rule_no
    }
  }

  dynamic "egress" {
    for_each = try(
      { for egress in each.value.egress : coalesce(egress.cidr_block, egress.ipv6_cidr_block) => egress },
      {}
    )

    content {
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
      protocol   = egress.value.protocol
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      rule_no    = egress.value.rule_no
    }
  }

  tags = merge(each.value.tags, {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = each.value.name
    "Type"                 = each.value.type
  })
}
