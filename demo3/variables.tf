
variable "aws_region" {
  description = "Region w którym AWS będzie stworzone"
  type = string
  default = "eu-central-1"

  validation {
    condition   = length(var.aws_region) > 2    
    error_message = "Region nie może być pusty"
  }

}

variable "instance_type" {
  description = "Instancja EC2 do utworzenia"
  type = string
  default ="t3.micro"
 
}

variable "instance_type_list" {
  description = "rodzaje instancji EC2 do wyboru"
  type = list(string)
  default = [
    "t3.small",
    "t3.micro",
    "c7i-flex.large",
    "m7i-flex.large"
  ]
}
variable "instance_tags" {
  description = "Tagi do przypisania do instancji EC2"
  type = map(string)
#   type = object({
#         Name = string
#         Environment = string
#         ManageByTerraform = bool
#     })
  default = {
    Name        = "Terraform Web Server"
    Environment = "dev"
    ManageByTerraform = "true"
  }
}




variable "instance_KeyPair" {
  description = "Nazwa pary kluczy do użycia z instancją EC2"
  type = string
  default = "frankfurt-key" # musi istnieć w AWS, aby można było się zalogować do instancji
}