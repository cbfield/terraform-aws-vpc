module "vpc_main" {
  source = "../"

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
      # VPC has to be created before this endpoint, so the `route_tables` output is populated
      route_table_ids = [for table in module.vpc_main.route_tables["back-end"] : table.id]
      # ... optional attributes
    },
    {
      service_name        = "com.amazonaws.us-east-1.execute-api"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      # ... optional attributes
    },
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
    },
  ]
}
