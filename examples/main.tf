module "my_vpc" {
  source = "../"

  name       = "main"
  cidr_block = "10.0.0.0/16"

  subnet_groups = [
    {
      type    = "public"
      name    = "public-default"
      prefix  = "10.0.0.0/16"
      newbits = 4
      availability_zones = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c"
      ]
      routes = [
        {
          cidr_block         = "10.20.0.0/16"
          transit_gateway_id = "tgw-123123"
        },
      ]
      nacl = {
        ingress = [
          {
            rule_number = 200
            protocol    = "tcp"
            rule_action = "allow"
            cidr_block  = "10.20.0.0/16"
            from_port   = 22
            to_port     = 22
          },
        ]
        egress = []
        tags   = {}
      }
      tags = {}
    }
  ]
}
