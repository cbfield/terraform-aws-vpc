resource "aws_route_table" "route_table" {
  for_each = {
    for table in flatten([
      for group in var.subnet_groups : [
        group.type == "private" ? [
          for az in var.availability_zones : merge(group, {
            az = az
            id = "${group.name}-${az}"
          })] : [
          merge(group, {
            az = join(",", var.availability_zones)
            id = group.name
        })]
      ]
    ]) : table.id => table
  }

  dynamic "route" {
    for_each = each.value.routes == null ? {} : {
      for route in each.value.routes : (
        route.cidr_block != null ? route.cidr_block : (
          route.ipv6_cidr_block != null ? route.ipv6_cidr_block : route.prefix_list_id
        )
      ) => route
    }

    content {
      cidr_block                 = route.value.cidr_block
      ipv6_cidr_block            = route.value.ipv6_cidr_block
      destination_prefix_list_id = route.value.prefix_list_id
      carrier_gateway_id         = route.value.carrier_gateway_id
      gateway_id                 = route.value.gateway_id
      instance_id                = route.value.instance_id
      nat_gateway_id             = route.value.nat_gateway_id
      network_interface_id       = route.value.network_interface_id
      transit_gateway_id         = route.value.transit_gateway_id
      vpc_endpoint_id            = route.value.vpc_endpoint_id
      vpc_peering_connection_id  = route.value.vpc_peering_connection_id
    }
  }

  dynamic "route" {
    for_each = each.value.type == "private" ? toset([1]) : toset([])

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.ngw[each.value.az].id
    }
  }

  dynamic "route" {
    for_each = each.value.type == "public" ? toset([1]) : toset([])

    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  }

  vpc_id = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Availability Zones"   = each.value.az
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-${each.value.id}"
    "Type"                 = each.value.type
  })
}
