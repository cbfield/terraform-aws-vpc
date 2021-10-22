resource "aws_subnet" "subnet" {
  for_each = {
    for subnet in flatten([
      for group in var.subnet_groups : [
        for az in group.availability_zones : [
          {
            assign_ipv6_address_on_creation = group.assign_ipv6_address_on_creation
            availability_zone               = az
            cidr_block                      = cidrsubnet(group.prefix, group.newbits, index(group.availability_zones, az))
            customer_owned_ipv4_pool        = group.customer_owned_ipv4_pool
            ipv6_cidr_block                 = group.ipv6_prefix == null || group.ipv6_newbits == null ? null : cidrsubnet(group.ipv6_prefix, group.ipv6_newbits, index(group.availability_zones, az))
            map_customer_owned_ip_on_launch = group.map_customer_owned_ip_on_launch
            map_public_ip_on_launch         = group.map_public_ip_on_launch
            outpost_arn                     = group.outpost_arn
            group_name                      = group.name
            name                            = "${var.name}-${group.name}-${az}"
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
    "Managed By Terraform" = "true"
    "Name"                 = each.value.name
    "Type"                 = each.value.type
  })
}
