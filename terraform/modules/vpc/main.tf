
data "yandex_compute_image" "my_image" {
  family = var.vm_guest
  #family = "ubuntu-2204-lts"
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
    subnet_id = var.subnet_id
    nat       = var.nat_ip
  }


  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.vm_ssh_public_key)}"
    user_data = <<-EOF
      - python3
      - python3-pip
    EOF
  }
}