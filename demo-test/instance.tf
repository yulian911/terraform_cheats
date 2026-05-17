resource "aws_instance" "master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.master.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name
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

resource "aws_instance" "database" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.database.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = false

  user_data = templatefile("${path.module}/templates/managed-user-data.tftpl", {
    admin_public_key   = local.admin_public_key
    ansible_public_key = local.ansible_public_key
  })

  tags = {
    Name = "${var.project_name}-database"
    Role = "database"
  }
}

resource "aws_instance" "webserver" {
  count                       = var.webservers_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  vpc_security_group_ids      = [aws_security_group.webserver.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/managed-user-data.tftpl", {
    admin_public_key   = local.admin_public_key
    ansible_public_key = local.ansible_public_key
  })

  tags = {
    Name = "${var.project_name}-webserver-${count.index + 1}"
    Role = "webserver"
  }
}