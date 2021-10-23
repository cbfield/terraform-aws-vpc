resource "aws_network_acl" "ngw_nacl" {
  subnet_ids = [for az in local.availability_zones : aws_subnet.ngw_subnet[az].id]
  vpc_id     = aws_vpc.vpc.id

  tags = {
    "Availability Zones"   = join(",", local.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway"
    "Type"                 = "public"
  }
}

resource "aws_network_acl_rule" "ngw_ingress" {
  for_each = toset(flatten([
    for group in var.subnet_groups : [
      for az in group.availability_zones : aws_subnet.subnet["${var.name}-${group.name}-${az}"].cidr_block
    ] if group.type == "private"
  ]))

  cidr_block     = each.value
  egress         = false
  from_port      = 0
  network_acl_id = aws_network_acl.ngw_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 1
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

  subnet_ids = [for az in each.value.availability_zones : aws_subnet.subnet["${var.name}-${each.value.name}-${az}"].id]
  vpc_id     = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Availability Zones"   = join(",", each.value.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = each.value.name
    "Type"                 = each.value.type
  })
}
