resource "aws_subnet" "ngw_subnet" {
  for_each = {
    for az in toset(local.zones) : az => {
      availability_zone = az
      cidr_block        = cidrsubnet(var.cidr_block, local.min_newbits, index(local.zones, az))
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

resource "aws_subnet" "subnet" {
  for_each = {
    for subnet in flatten([
      for group in var.subnet_groups : [
        for az in group.availability_zones : [
          {
            assign_ipv6_address_on_creation = group.assign_ipv6_address_on_creation
            availability_zone               = az
            cidr_block                      = cidrsubnet(var.cidr_block, group.newbits, group.first_netnum + index(sort(group.availability_zones), az))
            customer_owned_ipv4_pool        = group.customer_owned_ipv4_pool
            ipv6_cidr_block                 = var.assign_generated_ipv6_cidr_block == null || group.ipv6_prefix == null || group.ipv6_newbits == null ? null : cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, group.ipv6_newbits, group.ipv6_first_netnum + index(sort(group.availability_zones), az))
            map_customer_owned_ip_on_launch = group.map_customer_owned_ip_on_launch
            map_public_ip_on_launch         = group.map_public_ip_on_launch
            outpost_arn                     = group.outpost_arn
            group_name                      = group.name
            name                            = "${group.name}-${az}"
            tags                            = group.tags
            type                            = group.type
          }
        ]
      ]
    ]) : subnet.name => subnet
  }

  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation
  availability_zone               = each.value.availability_zone
  cidr_block                      = each.value.cidr_block
  customer_owned_ipv4_pool        = each.value.customer_owned_ipv4_pool
  ipv6_cidr_block                 = each.value.ipv6_cidr_block
  map_customer_owned_ip_on_launch = each.value.map_customer_owned_ip_on_launch
  map_public_ip_on_launch         = each.value.map_public_ip_on_launch
  outpost_arn                     = each.value.outpost_arn
  vpc_id                          = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Availability Zone"    = each.value.availability_zone
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-${each.value.name}"
    "Type"                 = each.value.type
  })
}
