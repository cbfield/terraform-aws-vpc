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

resource "aws_subnet" "ngw_subnet" {
  for_each = {
    for az in toset(var.availability_zones) : az => {
      availability_zone = az
      cidr_block        = cidrsubnet(var.cidr_block, 28 - parseint(split("/", var.cidr_block)[1], 10), index(var.availability_zones, az))
      name              = "${var.name}-nat-gateway-${az}"
  } }

  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.vpc.id

  tags = {
    "Availability Zone"    = each.value.availability_zone
    "Managed By Terraform" = "true"
    "Name"                 = each.value.name
    "Type"                 = "public"
  }
}

resource "aws_route_table" "ngw_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway"
    "Type"                 = "public"
  }
}
