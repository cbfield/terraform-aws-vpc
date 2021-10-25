module "public_vpc" {
  source = "../"

  name       = "main"
  cidr_block = "10.0.0.0/16"
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]

  bastion = {
    ami = data.aws_ami.al2.id
    subnets = [
      "sg-123123", # module.public_vpc.vpc.subnets["front-end"]["us-east-1a"].id,
      "sg-234234", # module.public_vpc.vpc.subnets["back-end"]["us-east-1a"].id,
    ]
    ingress = {
      cidr_blocks     = ["10.20.0.0/16"]
      security_groups = ["sg-123123"]
    }
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
      first_netnum = 4
    },
  ]

  vpc_endpoints = [
    {
      service_name        = "com.amazonaws.s3-global.s3"
      private_dns_enabled = true
      vpc_endpoint_type   = "Interface"
    }
  ]
}
