resource "aws_nat_gateway" "ngw" {
  for_each = toset(local.availability_zones)

  # allocation_id     = var.nat_gateways.allocation_id
  subnet_id = aws_subnet.ngw_subnet[each.key].id

  tags = {
    "Availability Zone"    = each.key
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway-${each.key}"
  }
}
