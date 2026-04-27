output "public_ip_vm" {
  description = "Публичный IP VM"
  value       = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}
output "ssh_user" {
  description = "Ssh User"
  value = var.vm_user
}

output "ssh_connection_string" {
  description = "ssh Connection string" 
  value = "ssh ${var.vm_user}@${yandex_compute_instance.vm.network_interface.0.nat_ip_address}"
}

output "private_ip_vm" {
  description = "Приветный IP VM"
  value       = yandex_compute_instance.vm.network_interface.0.ip_address
}