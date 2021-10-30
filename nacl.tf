resource "aws_network_acl" "nacl" {
  for_each = { for group in var.subnet_groups : group.name => group }

  subnet_ids = [for az in var.availability_zones : aws_subnet.subnet["${each.value.name}-${az}"].id]
  vpc_id     = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = try(length(each.value.nacl.ingress) > 0, false) ? {
      for ingress in [
        for ing in each.value.nacl.ingress : ing if ing.subnet_group == null
      ] : ingress.rule_no => ingress
    } : {}

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

  dynamic "ingress" {
    for_each = try(length(each.value.nacl.ingress) > 0, false) ? {
      for ingress in flatten([
        for ing in each.value.nacl.ingress : [
          for az in var.availability_zones : merge(ing, { az = az })
        ] if ing.subnet_group != null
      ]) : ingress.rule_no + index(sort(var.availability_zones), ingress.az) => ingress
    } : {}

    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      action          = ingress.value.action
      cidr_block      = aws_subnet.subnet["${ingress.value.subnet_group}-${ingress.value.az}"].cidr_block
      ipv6_cidr_block = ingress.value.ipv6_cidr_block
      rule_no         = ingress.value.rule_no + index(sort(var.availability_zones), ingress.value.az)
    }
  }

  dynamic "egress" {
    for_each = try(length(each.value.nacl.egress) > 0, false) ? {
      for egress in [
        for eg in each.value.nacl.egress : eg if eg.subnet_group == null
      ] : egress.rule_no => egress
    } : {}

    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      action          = egress.value.action
      cidr_block      = egress.value.cidr_block
      ipv6_cidr_block = egress.value.ipv6_cidr_block
      rule_no         = egress.value.rule_no
    }
  }

  dynamic "egress" {
    for_each = try(length(each.value.nacl.egress) > 0, false) ? {
      for egress in flatten([
        for eg in each.value.nacl.egress : [
          for az in var.availability_zones : merge(eg, { az = az })
        ] if eg.subnet_group != null
      ]) : egress.rule_no + index(sort(var.availability_zones), egress.az) => egress
    } : {}

    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      action          = egress.value.action
      cidr_block      = aws_subnet.subnet["${egress.value.subnet_group}-${egress.value.az}"].cidr_block
      ipv6_cidr_block = egress.value.ipv6_cidr_block
      rule_no         = egress.value.rule_no + index(sort(var.availability_zones), egress.value.az)
    }
  }

  tags = merge(each.value.tags, {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-${each.value.name}"
    "Type"                 = each.value.type
  })
}
