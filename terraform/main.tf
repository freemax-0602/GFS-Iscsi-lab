
module "vpc-1" {
    source = "./modules/vpc"
    vm_zone = "ru-central1-a"
    vm_ssh_public_key = "~/.ssh/id_ed25519.pub"
    // Параметры диска
    disk_name = "iscsi-disk"
    disk_type = "network-hdd"
    disk_size = 50
    // Параметры ВМ
    vm_name = "iscsi-target"
    vm_hostname = "iscsi1"
    vm_platform_id = "standard-v3"
    vm_cpu = 2
    vm_ram = 2
}

module "vpc-2" {
    source = "./modules/vpc"
    vm_zone = "ru-central1-a"
    vm_ssh_public_key = "~/.ssh/id_ed25519.pub"
    // Параметры диска
    disk_name = "vm-1-disk"
    disk_type = "network-hdd"
    disk_size = 25
    // Параметры ВМ
    vm_name = "gfs-node-1"
    vm_hostname = "gfs1"
    vm_platform_id = "standard-v3"
    vm_cpu = 2
    vm_ram = 2
}

module "vpc-3" {
    source = "./modules/vpc"
    vm_zone = "ru-central1-a"
    vm_ssh_public_key = "~/.ssh/id_ed25519.pub"
    // Параметры диска
    disk_name = "vm-2-disk"
    disk_type = "network-hdd"
    disk_size = 25
    // Параметры ВМ
    vm_name = "gfs-node-2"
    vm_hostname = "gfs2"
    vm_platform_id = "standard-v3"
    vm_cpu = 2
    vm_ram = 2
}

module "vpc-4" {
    source = "./modules/vpc"
    vm_zone = "ru-central1-a"
    vm_ssh_public_key = "~/.ssh/id_ed25519.pub"
    // Параметры диска
    disk_name = "vm-3-disk"
    disk_type = "network-hdd"
    disk_size = 25
    // Параметры ВМ
    vm_name = "gfs-node-3"
    vm_hostname = "gfs3"
    vm_platform_id = "standard-v3"
    vm_cpu = 2
    vm_ram = 2
}

output "vpc_1_public_ip" {
    value = module.vpc-1.public_ip_vm
}

output "vpc_1_private_ip" {
   value = module.vpc-1.private_ip_vm
}

output "vpc_2_public_ip" {
    value = module.vpc-2.public_ip_vm
}

output "vpc_2_private_ip" {
    value = module.vpc-2.private_ip_vm
}

output "vpc_3_public_ip" {
    value = module.vpc-3.public_ip_vm
}

output "vpc_3_private_ip" {
    value = module.vpc-3.private_ip_vm
}

output "vpc_4_public_ip" {
    value = module.vpc-4.public_ip_vm
}

output "vpc_4_private_ip" {
    value = module.vpc-4.private_ip_vm
}