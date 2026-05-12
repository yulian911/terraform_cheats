locals {
  common_tags = {
    Name        = "Terraform Web Server"
    Environment = "dev"
    ManageByTerraform = "true"

  }
  AppName     = "${local.common_tags.Name}_${local.common_tags.Environment}"
}