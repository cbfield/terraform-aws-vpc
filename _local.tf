locals {
  availability_zones = sort(distinct(flatten([for group in var.subnet_groups : group.availability_zones])))
  min_newbits        = 28 - parseint(split("/", var.cidr_block)[1], 10)
}
