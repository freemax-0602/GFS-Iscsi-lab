
data "yandex_compute_image" "my_image" {
  family = "ubuntu-2204-lts"
}

data "yandex_vpc_subnet" "default" {

  name = "default-ru-central1-a"
}

resource "yandex_compute_disk" "boot-disk" {
  name     = var.disk_name
  type     = var.disk_type
  zone     = var.vm_zone
  size     = var.disk_size
  image_id = data.yandex_compute_image.my_image.id
}

resource "yandex_compute_instance" "vm" {
  name                      = var.vm_name
  hostname                  = var.vm_hostname
  allow_stopping_for_update = true
  platform_id               = var.vm_platform_id
  zone                      = var.vm_zone

  resources {
    cores  = var.vm_cpu
    memory = var.vm_ram
  }

  boot_disk {
    auto_delete = true
    disk_id     = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.vm_ssh_public_key)}"
  }
}