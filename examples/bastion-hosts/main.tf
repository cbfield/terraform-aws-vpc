module "vpc_main" {
  source = "../"

  name       = "main"
  cidr_block = "10.0.0.0/16"
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
  ]

  bastion = {
    subnets = [
      # VPC must be created before adding this, so this output is populated
      module.vpc_main.subnets["front-end"]["us-east-1a"].id
    ]
    ingress = {
      cidr_blocks     = ["123.123.123.123"]
      security_groups = ["sg-123123"]
    }
    # ami = "ami-123123"         # Amazon Linux 2 Latest, if not specified
    # public_key = "ssh-rsa ..." # a key is generated, if not specified
  }

  subnet_groups = [
    {
      type         = "public"
      name         = "front-end"
      newbits      = 8
      first_netnum = 1
    },
    {
      type         = "private"
      name         = "back-end"
      newbits      = 8
      first_netnum = 3
    }
  ]
}
