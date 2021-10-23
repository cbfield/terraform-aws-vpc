resource "aws_route_table" "ngw_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Availability Zones"   = join(",", var.availability_zones)
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-nat-gateway"
    "Type"                 = "public"
  }
}

resource "aws_route_table" "route_table" {
  for_each = {
    for table in flatten([
      for group in var.subnet_groups : [
        group.type == "public" || group.type == "airgapped" ? [{
          availability_zone = join(",", var.availability_zones)
          name              = group.name
          tags              = group.tags
          type              = group.type
          }] : [
          for az in var.availability_zones : {
            availability_zone = az
            name              = "${group.name}-${az}"
            tags              = group.tags
            type              = group.type
        }]
      ]
    ]) : table.name => table
  }

  vpc_id = aws_vpc.vpc.id
  tags = merge(each.value.tags, {
    "Availability Zones"   = each.value.availability_zone
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-${each.value.name}"
    "Type"                 = each.value.type
  })
}

resource "aws_route_table_association" "ngw_igw_association" {
  route_table_id = aws_route_table.ngw_route_table.id
  gateway_id     = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_igw_association" {
  for_each = { for group in var.subnet_groups : group.name => group if group.type == "public" }

  route_table_id = aws_route_table.route_table[each.key].id
  gateway_id     = aws_internet_gateway.igw.id
}
