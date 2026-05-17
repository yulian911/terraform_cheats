locals {
  admin_public_key    = trimspace(file(var.admin_public_key_path))
  ansible_public_key  = trimspace(file(var.ansible_public_key_path))
  ansible_private_key = trimspace(file(var.ansible_private_key_path))
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "master" {
  name        = "${var.project_name}-${var.environment}-master-sg"
  description = "Security group for master instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-master-sg"
  }
}

resource "aws_security_group" "managed" {
  name        = "${var.project_name}-${var.environment}-managed-sg"
  description = "Security group for managed instances"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "SSH from master security group"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.master.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-managed-sg"
  }
}

resource "aws_instance" "master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.master.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

 user_data = templatefile("${path.module}/templates/master-user-data.tftpl", {
  admin_public_key    = local.admin_public_key
  ansible_public_key  = local.ansible_public_key
  ansible_private_key = local.ansible_private_key
})

  tags = {
    Name = "${var.project_name}-master"
    Role = "master"
  }
}

resource "aws_instance" "managed" {
  count                       = var.managed_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.managed.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/managed-user-data.tftpl", {
    admin_public_key   = local.admin_public_key
    ansible_public_key = local.ansible_public_key
  })

  tags = {
    Name = "${var.project_name}-node-${count.index + 1}"
    Role = "managed"
  }
}