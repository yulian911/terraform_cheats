# outputs tf służywa do definiowania wartości, które chcemy wyświetlić po wykonaniu terraform apply. W tym przypadku chcemy wyświetlić publiczny adres IP naszej instancji EC2.

# output "public_dns" {
#   value = aws_instance.web[*].public_dns
#   description = " Output the value of dns"
# }

# output "public_ip" {
#   value = aws_instance.web[*].public_ip
#   description = " Output the value of ip"
# }


# output dla listy 

output "output_with_list" {
  description = "dla pętłi "
  value       = [for instance in aws_instance.web : instance.public_ip]
}

output "output_with_list_dns" {
  description = "dla pętłi dns "
  value       = { for i in aws_instance.web : i.public_ip => i.public_dns }
}

#  all availlable AZs pokazuje wszystkie dostępne strefy dostępności w regionie, które zostały pobrane za pomocą data source aws_availability_zones. Wartość tego outputu będzie listą nazw stref dostępności, które są dostępne do użytokowania bez konieczności dodatkowej konfiguracji (opt-in-not-required).


output "all-availabile-AZs" {
  value = data.aws_availability_zones.available.names
}

# all supported AZs pokazuje wszystkie strefy dostępności, które obsługują określony typ instancji EC2 (var.instance_type) w regionie. Wartość tego outputu będzie mapą, gdzie kluczem jest nazwa strefy dostępności, a wartością są szczegóły dotyczące oferty typu instancji w tej strefie dostępności.


output "all-supported-AZs" {
  value = keys({
    for az, details in data.aws_ec2_instance_type_offerings.my_instance_type :
    az => details.instance_types if length(details.instance_types) != 0
  })
}
