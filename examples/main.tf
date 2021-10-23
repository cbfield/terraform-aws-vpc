module "my_vpc" {
  source = "../"

  name       = "main"
  cidr_block = "10.0.0.0/16"

  subnet_groups = [
    {
      type         = "public"
      name         = "public-default"
      newbits      = 8
      first_netnum = 1
      availability_zones = [
        "us-east-1a",
        "us-east-1b",
      ]
    },
    {
      type         = "private"
      name         = "private-default"
      newbits      = 8
      first_netnum = 3
      availability_zones = [
        "us-east-1a",
        "us-east-1b",
      ]
    },
  ]
}
