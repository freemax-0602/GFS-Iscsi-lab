resource "yandex_vpc_network" "lab-net" {
  name        = var.net_name
  description = var.netowrk_description
}

resource "yandex_vpc_subnet" "lab-subnet-a" {
  name           = var.subnet_name
  description    = var.subnet_description
  v4_cidr_blocks = var.subnet_cidr
  zone           = var.zone
  network_id     = "${yandex_vpc_network.lab-net.id}"
}
