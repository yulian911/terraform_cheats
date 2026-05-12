terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.44.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

}

resource "aws_instance" "web" {
  ami           = "ami-08bdb1495db49a7f9"
  instance_type = "t3.micro"
  
  tags = {
        Name = "Terraform Web Server"
    }

}