# modules/network/outputs.tf
output "network_id" {
  value = yandex_vpc_network.lab-net.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.lab-subnet-a.id
}