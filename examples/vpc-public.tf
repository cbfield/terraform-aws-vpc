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
      module.public_vpc.vpc.subnets["front-end"]["us-east-1a"].id,
      module.public_vpc.vpc.subnets["back-end"]["us-east-1a"].id,
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
      nacl = {
        ingress = [{
          cidr_block  = "0.0.0.0/0"
          from_port   = 0
          protocol    = "-1"
          rule_action = "allow"
          rule_number = 1000
          to_port     = 0
        }]
        egress = [{
          cidr_block  = "0.0.0.0/0"
          from_port   = 0
          protocol    = "-1"
          rule_action = "allow"
          rule_number = 1000
          to_port     = 0
        }]
      }
    },
    {
      type         = "private"
      name         = "back-end"
      newbits      = 8
      first_netnum = 3
      nacl         = { self_ingress = true }
    },
    {
      type         = "private"
      name         = "persistence"
      newbits      = 8
      first_netnum = 5
    },
    {
      type         = "airgapped"
      name         = "persistence-airgapped"
      newbits      = 8
      first_netnum = 7
    },
  ]
}
