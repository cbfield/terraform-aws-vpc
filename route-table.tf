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

  vpc_id = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Availability Zones"   = each.value.az
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-${each.value.id}"
    "Type"                 = each.value.type
  })
}

resource "aws_route" "igw_route" {
  for_each = toset(flatten([
    for group in var.subnet_groups : group.name if group.type == "public"
  ]))

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.route_table[each.key].id
}

resource "aws_route" "ngw_route" {
  for_each = {
    for route in flatten([
      for group in var.subnet_groups : [
        for az in var.availability_zones : {
          az             = az
          route_table_id = "${group.name}-${az}"
        }
      ] if group.type == "private"
    ]) : route.route_table_id => route
  }

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[each.value.az].id
  route_table_id         = aws_route_table.route_table[each.key].id
}

resource "aws_route" "route" {
  for_each = {
    for route in flatten([
      for group in var.subnet_groups : group.type == "private" ? flatten([
        for az in var.availability_zones : [
          for route in coalesce(group.routes, []) : merge(route, {
            destination = coalesce(
              route.cidr_block,
              route.ipv6_cidr_block,
              route.prefix_list_id
            )
            route_table_id = "${group.name}-${az}"
          })
        ]
        ]) : [
        for route in coalesce(group.routes, []) : merge(route, {
          destination = coalesce(
            route.cidr_block,
            route.ipv6_cidr_block,
            route.prefix_list_id
          )
          route_table_id = group.name
        })
      ]
    ]) : "${route.route_table_id}-${route.destination}" => route
  }

  carrier_gateway_id          = each.value.carrier_gateway_id
  destination_cidr_block      = each.value.cidr_block
  destination_ipv6_cidr_block = each.value.ipv6_cidr_block
  destination_prefix_list_id  = each.value.prefix_list_id
  egress_only_gateway_id      = each.value.egress_only_gateway_id
  gateway_id                  = each.value.gateway_id
  nat_gateway_id              = each.value.nat_gateway_id
  local_gateway_id            = each.value.local_gateway_id
  network_interface_id        = each.value.network_interface_id
  route_table_id              = aws_route_table.route_table[each.value.route_table_id].id
  transit_gateway_id          = each.value.transit_gateway_id
  vpc_endpoint_id             = each.value.vpc_endpoint_id
  vpc_peering_connection_id   = each.value.vpc_peering_connection_id
}

resource "aws_route_table_association" "association" {
  for_each = {
    for association in flatten([
      for group in var.subnet_groups : [
        for az in var.availability_zones : {
          az         = az
          group_name = group.name
          type       = group.type
        }
      ]
    ]) : "${association.group_name}-${association.az}" => association
  }

  route_table_id = each.value.type == "private" ? (
    aws_route_table.route_table["${each.value.group_name}-${each.value.az}"].id
    ) : (
    aws_route_table.route_table[each.value.group_name].id
  )

  subnet_id = aws_subnet.subnet["${each.value.group_name}-${each.value.az}"].id
}
