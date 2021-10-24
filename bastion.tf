resource "aws_instance" "bastion" {
  for_each = try(toset(var.bastion.subnets), toset([]))

  ami                    = try(var.bastion.ami, data.aws_ami.al2.0.id)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.bastion_ec2_key.0.id
  security_groups        = [aws_security_group.bastion.0.id]
  vpc_security_group_ids = [each.key]

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    "Managed By Terraform" = "true"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "tls_private_key" "bastion_ssh_key" {
  count = var.bastion != null && try(var.bastion.public_key == null, true) ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_ec2_key" {
  count = var.bastion != null ? 1 : 0

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
  count = var.bastion != null ? 1 : 0

  description = "Manages ingress and egress for bastion hosts in VPC ${var.name}"
  name        = "${var.name}-bastion"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    "Managed By Terraform" = "true"
  }
}

resource "aws_security_group_rule" "bastion_self_ingress" {
  count = var.bastion != null ? 1 : 0

  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.0.id
  self              = true
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_cidr_ingress" {
  count = try(length(var.bastion.ingress.cidr_blocks) > 0, false) ? 1 : 0

  cidr_blocks       = var.bastion.ingress.cidr_blocks
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.0.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_sg_ingress" {
  for_each = try(toset(var.bastion.ingress.security_groups), toset([]))

  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion.0.id
  source_security_group_id = each.key
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "bastion_egress" {
  count = var.bastion != null ? 1 : 0

  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.bastion.0.id
  to_port           = 0
  type              = "egress"
}
