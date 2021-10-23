locals {
  min_newbits   = 28 - parseint(split("/", var.cidr_block)[1], 10)
  subnet_groups = sort([for group in var.subnet_groups : group.name])
}
