resource "tls_private_key" "bastion_ssh_key" {
  count = var.bastion != {} ? var.bastion.public_key != null ? 1 : 0 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_ec2_key" {
  count = var.bastion != {} ? 1 : 0

  key_name   = "${var.name}-bastion"
  public_key = var.bastion.public_key != null ? var.bastion.public_key : tls_private_key.ssh_key.0.public_key_openssh

  tags = {
    "Managed By Terraform" = "true"
  }
}

resource "aws_security_group" "bastion" {
  description = "Manages ingress and egress for bastion hosts in VPC ${name}"
  name        = "${var.name}-bastion"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    "Managed By Terraform" = "true"
  }
}

resource "aws_security_group_rule" "bastion_cidr_ingress" {
  count = var.bastion != null ? var.bastion.ingress != null ? var.bastion.ingress.cidr_blocks != null ? length(var.bastion.ingress.cidr_blocks) > 0 ? 1 : 0 : 0 : 0 : 0

  cidr_blocks       = var.bastion.ingress.cidr_blocks
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_sg_ingress" {
  for_each = var.bastion != null ? var.bastion.ingress != null ? var.bastion.ingress.security_groups != null ? toset(var.bastion.ingress.security_groups) : toset([]) : toset([]) : toset([])

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
