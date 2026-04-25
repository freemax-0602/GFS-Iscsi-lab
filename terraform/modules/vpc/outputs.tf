output "public_ip_vm" {
  description = "Публичный IP VM"
  value       = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}

output "private_ip_vm" {
  description = "Приветный IP VM"
  value       = yandex_compute_instance.vm.network_interface.0.ip_address
}