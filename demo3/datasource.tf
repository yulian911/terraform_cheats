data "aws_ami" "aws_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"] # Amazon Linux 2023 AMI (x86_64) - Kernel 6.1
  }
}

# Poniżej znajduje się data source aws_availability_zones, który służy do pobierania informacji o dostępnych strefach dostępności (availability zones) w regionie AWS. W tym przypadku, filtrujemy strefy dostępności, aby uwzględnić tylko te, które nie wymagają opt-in (opt-in-not-required). Dzięki temu możemy uzyskać listę stref dostępności, które są dostępne do użytokowania bez konieczności dodatkowej konfiguracji.


data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


data "aws_ec2_instance_type_offerings" "my_instance_type" {
  for_each = toset(data.aws_availability_zones.available.names)
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}
