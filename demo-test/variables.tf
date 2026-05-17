variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
  nullable    = false

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region nie może być pusty."
  }
}

variable "project_name" {
  description = "Nazwa projektu używana w tagach i nazwach zasobów"
  type        = string
  default     = "ansible-demo-test"
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name może zawierać tylko małe litery, cyfry i myślniki."
  }
}

variable "environment" {
  description = "Środowisko"
  type        = string
  default     = "dev"
  nullable    = false

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "environment musi być jednym z: dev, test, stage, prod."
  }
}

variable "instance_type" {
  description = "Typ instancji EC2"
  type        = string
  default     = "t3.micro"
  nullable    = false

  validation {
    condition     = can(regex("^t[23][a-zA-Z0-9.]*$", var.instance_type))
    error_message = "instance_type musi należeć do rodziny t2/t3, np. t3.micro."
  }
}

variable "webservers_count" {
  description = "Liczba webserwerów"
  type        = number
  default     = 2
  nullable    = false

  validation {
    condition     = var.webservers_count >= 1 && var.webservers_count <= 10
    error_message = "webservers_count musi być w zakresie 1-10."
  }
}

variable "key_name" {
  description = "Nazwa key pair w AWS"
  type        = string
  default     = "ansible-key"
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.key_name))
    error_message = "key_name może zawierać tylko litery, cyfry, kropki, podkreślenia i myślniki."
  }
}

variable "ami_id" {
  description = "AMI ID dla instancji EC2"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^ami-[a-zA-Z0-9]+$", var.ami_id))
    error_message = "ami_id musi wyglądać jak poprawne AMI ID, np. ami-1234567890abcdef0."
  }
}
variable "admin_public_key_path" {
  description = "Ścieżka do lokalnego klucza publicznego administratora"
  type        = string
  nullable    = false

  validation {
    condition     = length(var.admin_public_key_path) > 0
    error_message = "admin_public_key_path nie może być pusty."
  }
}

variable "ansible_public_key_path" {
  description = "Ścieżka do publicznego klucza Ansible"
  type        = string
  nullable    = false

  validation {
    condition     = length(var.ansible_public_key_path) > 0
    error_message = "ansible_public_key_path nie może być pusty."
  }
}
variable "ansible_private_key_path" {
  description = "Ścieżka do prywatnego klucza Ansible, który trafi na master"
  type        = string
  nullable    = false
  sensitive   = true

  validation {
    condition     = length(var.ansible_private_key_path) > 0
    error_message = "ansible_private_key_path nie może być pusty."
  }
}


variable "my_ip_cidr" {
  description = "Twój publiczny adres IP w formacie CIDR do SSH, np. 1.2.3.4/32"
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrsubnet(var.my_ip_cidr, 0, 0))
    error_message = "my_ip_cidr musi być poprawnym CIDR, np. 1.2.3.4/32."
  }
}

