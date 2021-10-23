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
