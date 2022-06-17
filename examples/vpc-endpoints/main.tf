module "vpc_main" {
  source = "../../"

  name       = "main"
  cidr_block = "10.0.0.0/16"
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
  ]

  vpc_endpoints = [
    {
      service_name      = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type = "Gateway"
      route_tables      = [{ subnet_group = "back-end" }]
    },
    {
      service_name        = "com.amazonaws.us-east-1.execute-api"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
    }
  ]

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
