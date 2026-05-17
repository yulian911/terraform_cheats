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

output "managed_instance_ids" {
  description = "ID instancji managed"
  value       = aws_instance.managed[*].id
}



output "managed_private_ips" {
  description = "Prywatne IP instancji managed"
  value       = aws_instance.managed[*].private_ip
}



output "managed_public_ips" {
  description = "Publiczne IP instancji managed"
  value = [for i in aws_instance.managed : i.public_ip]
}
