
# Master outputs
output "master_instance_id" {
  description = "ID instancji master"
  value       = aws_instance.master.id
}

output "master_public_ip" {
  description = "Publiczny IP instancji master"
  value       = aws_instance.master.public_ip
}

output "master_private_ip" {
  description = "Prywatny IP instancji master"
  value       = aws_instance.master.private_ip
}


# webserver outputs
output "webserver_instance_ids" {
  description = "ID instancji webserwerów"
  value       = aws_instance.webserver[*].id
}



output "webserver_private_ips" {
  description = "Prywatne IP instancji webserwerów"
  value       = aws_instance.webserver[*].private_ip
}



output "webserver_public_ips" {
  description = "Publiczne IP instancji webserwerów"
  value = [for i in aws_instance.webserver : i.public_ip]
}

output "webserwer_list" {
    value = { for i in aws_instance.webserver : i.public_ip => i.public_dns }
}

# Database outputs

output "database_public_ip" {
  description = "Publiczny IP instancji bazy danych"
  value       = aws_instance.database.public_ip
}



output "database_private_ip" {
  description = "Prywatny IP instancji bazy danych"
  value       = aws_instance.database.private_ip
}

output "database_instance_id" {
  description = "ID instancji bazy danych"
  value       = aws_instance.database.id
}


