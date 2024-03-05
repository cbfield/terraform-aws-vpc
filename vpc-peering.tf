resource "aws_vpc_peering_connection" "peer" {
  for_each = { for peer in var.vpc_peering_connections : peer.peer_vpc_id => peer }

  auto_accept   = each.value.auto_accept
  peer_owner_id = each.value.peer_owner_id
  peer_region   = each.value.peer_region
  peer_vpc_id   = each.value.peer_vpc_id
  vpc_id        = aws_vpc.vpc.id

  dynamic "accepter" {
    for_each = each.value.accepter != null ? toset([1]) : toset([])

    content {
      allow_remote_vpc_dns_resolution  = each.value.accepter.allow_remote_vpc_dns_resolution
    }
  }

  dynamic "requester" {
    for_each = each.value.requester != null ? toset([1]) : toset([])

    content {
      allow_remote_vpc_dns_resolution  = each.value.requester.allow_remote_vpc_dns_resolution
    }
  }

  tags = merge(each.value.tags, {
    "Managed By Terraform" = "true"
  })
}

resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  for_each = { for peer in var.vpc_peering_connection_accepters : peer.vpc_peering_connection_id => peer }

  auto_accept               = each.value.auto_accept
  vpc_peering_connection_id = each.value.vpc_peering_connection_id

  tags = merge(each.value.tags, {
    "Managed By Terraform" = "true"
  })
}
