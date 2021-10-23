resource "aws_route" "ngw_route" {
  for_each = {
    for table in flatten([
      for group in var.subnet_groups : [
        for az in var.availability_zones : {
          nat_gateway_id = aws_nat_gateway.ngw[az].id
          route_table    = "${group.name}-${az}"
      }] if group.type == "private"
    ]) : table.route_table => table
  }

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.nat_gateway_id
  route_table_id         = aws_route_table.route_table[each.value.route_table].id
}

resource "aws_route" "route" {
  for_each = {
    for route in flatten([
      for group in var.subnet_groups : group.routes == null ? [] : [
        for route in group.routes :
        group.type == "public" || group.type == "persistence" ? [{
          carrier_gateway_id          = route.carrier_gateway_id
          destination                 = route.destination_cidr_block != null ? route.destination_cidr_block : route.destination_ipv6_cidr_block != null ? route.destination_ipv6_cidr_block : route.destination_prefix_list_id
          destination_cidr_block      = route.destination_cidr_block
          destination_ipv6_cidr_block = route.destination_ipv6_cidr_block
          destination_prefix_list_id  = route.destination_prefix_list_id
          egress_only_gateway_id      = route.egress_only_gateway_id
          gateway_id                  = route.gateway_id
          instance_id                 = route.instance_id
          local_gateway_id            = route.local_gateway_id
          nat_gateway_id              = route.nat_gateway_id
          network_interface_id        = route.network_interface_id
          route_table                 = group.name
          transit_gateway_id          = route.transit_gateway_id
          vpc_endpoint_id             = route.vpc_endpoint_id
          vpc_peering_connection_id   = route.vpc_peering_connection_id
          }] : [
          for az in var.availability_zones : {
            carrier_gateway_id          = route.carrier_gateway_id
            destination                 = route.destination_cidr_block != null ? route.destination_cidr_block : route.destination_ipv6_cidr_block != null ? route.destination_ipv6_cidr_block : route.destination_prefix_list_id
            destination_cidr_block      = route.destination_cidr_block
            destination_ipv6_cidr_block = route.destination_ipv6_cidr_block
            destination_prefix_list_id  = route.destination_prefix_list_id
            egress_only_gateway_id      = route.egress_only_gateway_id
            gateway_id                  = route.gateway_id
            instance_id                 = route.instance_id
            local_gateway_id            = route.local_gateway_id
            nat_gateway_id              = route.nat_gateway_id
            network_interface_id        = route.network_interface_id
            route_table                 = "${group.name}-${az}"
            transit_gateway_id          = route.transit_gateway_id
            vpc_endpoint_id             = route.vpc_endpoint_id
            vpc_peering_connection_id   = route.vpc_peering_connection_id
          }
        ]
      ]
    ]) : "${route.route_table}-${route.destination}" => route
  }

  destination_cidr_block      = each.value.destination_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  destination_prefix_list_id  = each.value.destination_prefix_list_id
  egress_only_gateway_id      = each.value.egress_only_gateway_id
  gateway_id                  = each.value.gateway_id
  instance_id                 = each.value.instance_id
  local_gateway_id            = each.value.local_gateway_id
  nat_gateway_id              = each.value.nat_gateway_id
  network_interface_id        = each.value.network_interface_id
  route_table_id              = aws_route_table.route_table[each.value.route_table].id
  transit_gateway_id          = each.value.transit_gateway_id
  vpc_endpoint_id             = each.value.vpc_endpoint_id
  vpc_peering_connection_id   = each.value.vpc_peering_connection_id
}
