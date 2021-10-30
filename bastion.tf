resource "aws_instance" "bastion" {
  for_each = try(toset(var.bastion.subnets), toset([]))

  ami                    = coalesce(try(var.bastion.ami, null), data.aws_ami.al2.0.id)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.bastion_ec2_key.id
  subnet_id              = each.key
  vpc_security_group_ids = [aws_security_group.bastion.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-bastion-${lookup(data.aws_subnet.bastion_subnet[each.key].tags, "Name", each.key)}"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "tls_private_key" "bastion_ssh_key" {
  count = try(var.bastion.public_key == null, true) ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_ec2_key" {
  key_name = "${var.name}-bastion"

  public_key = coalesce(
    try(var.bastion.public_key, null),
    tls_private_key.bastion_ssh_key.0.public_key_openssh
  )
  tags = {
    "Managed By Terraform" = "true"
  }
}

resource "aws_security_group" "bastion" {
  description = "Manages ingress and egress for bastion hosts in VPC ${var.name}"
  name        = "${var.name}-bastion"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    "Managed By Terraform" = "true"
  }
}

resource "aws_security_group_rule" "bastion_self_ingress" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  self              = true
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_cidr_ingress" {
  count = try(length(var.bastion.ingress.cidr_blocks) > 0, false) ? 1 : 0

  cidr_blocks       = var.bastion.ingress.cidr_blocks
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_sg_ingress" {
  for_each = toset(coalesce(try(var.bastion.ingress.security_groups, null), []))

  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion.id
  source_security_group_id = each.key
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "bastion_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.bastion.id
  to_port           = 0
  type              = "egress"
}
