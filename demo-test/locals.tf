locals {
  admin_public_key    = replace(trimspace(file(var.admin_public_key_path)), "\r", "")
  ansible_public_key  = replace(trimspace(file(var.ansible_public_key_path)), "\r", "")
  ansible_private_key = replace(trimspace(file(var.ansible_private_key_path)), "\r", "")
}