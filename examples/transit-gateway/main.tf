module "vpc_main" {
  source = "../../"

  name       = "main"
  cidr_block = "10.0.0.0/16"
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
  ]

  transit_gateway_attachments = [
    {
      transit_gateway_id = "tgw-123123"
      # ... optional attributes
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
      routes = [
        {
          cidr_block         = "10.10.0.0/16"
          transit_gateway_id = "tgw-123123"
        }
      ]
    }
  ]
}
