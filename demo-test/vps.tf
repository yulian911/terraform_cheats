data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name = "${var.project_name}-${var.environment}-vpc"
  cidr = "10.0.0.0/16"

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnets = [
    for i in range(2) :
    cidrsubnet("10.0.0.0/16", 8, i + 10)
  ]

  private_subnets = [
    for i in range(2) :
    cidrsubnet("10.0.0.0/16", 8, i + 20)
  ]

  public_subnet_names = [
    for i in range(2) :
    "public-subnet-${i + 1}"
  ]

  private_subnet_names = [
    for i in range(2) :
    "private-subnet-${i + 1}"
  ]

  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_security_group = false

  map_public_ip_on_launch = true

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}