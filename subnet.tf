resource "aws_subnet" "subnet" {
  for_each = {
    for subnet in flatten([
      for group in var.subnet_groups : [
        for az in var.availability_zones : [
          merge(group, {
            az        = az
            id        = "${group.name}-${az}"
            public_ip = coalesce(group.map_public_ip_on_launch, group.type == "public")

            cidr_block = cidrsubnet(
              var.cidr_block,
              group.newbits,
              group.first_netnum + index(sort(var.availability_zones), az)
            )

            ipv6_cidr_block = ((
              var.assign_generated_ipv6_cidr_block == null ||
              group.ipv6_prefix == null ||
              group.ipv6_newbits == null
              ) ? null :
              cidrsubnet(
                aws_vpc.vpc.ipv6_cidr_block,
                group.ipv6_newbits,
                group.ipv6_first_netnum + index(sort(var.availability_zones), az)
              )
            )
          })
        ]
      ]
    ]) : subnet.id => subnet
  }

  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation
  availability_zone               = each.value.az
  cidr_block                      = each.value.cidr_block
  customer_owned_ipv4_pool        = each.value.customer_owned_ipv4_pool
  ipv6_cidr_block                 = each.value.ipv6_cidr_block
  map_customer_owned_ip_on_launch = each.value.map_customer_owned_ip_on_launch
  map_public_ip_on_launch         = each.value.public_ip
  outpost_arn                     = each.value.outpost_arn
  vpc_id                          = aws_vpc.vpc.id

  tags = merge(each.value.tags, {
    "Availability Zone"    = each.value.az
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-${each.value.id}"
    "Type"                 = each.value.type
  })
}
