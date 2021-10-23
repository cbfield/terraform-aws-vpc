resource "aws_nat_gateway" "ngw" {
  for_each = toset(var.availability_zones)

  allocation_id = aws_eip.ngw_eip[each.key].id
  subnet_id     = aws_subnet.ngw_subnet[each.key].id

  tags = {
    "Availability Zone"    = each.key
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway-${each.key}"
  }
}

resource "aws_eip" "ngw_eip" {
  for_each = toset(var.availability_zones)

  vpc = true

  tags = {
    "Availability Zone"    = each.key
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway-${each.key}"
  }

  depends_on = [aws_internet_gateway.igw]
}
