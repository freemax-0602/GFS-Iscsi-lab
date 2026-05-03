module "service_account" {
  source = "./modules/service_account"
  serviceAccount_Name = var.serviceAccount_Name
  serviceAccount_Description = var.serviceAccount_Description
  serviceAccount_folder_id = var.folder_id
  serviceAccount_role = var.serviceAccount_role
}

 module "net" {
   source = "./modules/net"
   net_name = "lab-net"
   subnet_name = "lab-subnet-a"
   subnet_cidr = ["10.2.0.0/16"]
   zone        = "ru-central1-a"
}


# module "vpc-1" {
#     source = "./modules/vpc"
#     vm_zone = "ru-central1-a"
#     vm_guest = "centos-7"
#     vm_ssh_public_key = "~/.ssh/id_ed25519.pub"
#     // Параметры диска
#     disk_name = "iscsi-disk"
#     disk_type = "network-hdd"
#     disk_size = 50
#     // Параметры ВМ
#     vm_name = "iscsi-target"
#     vm_hostname = "iscsi1"
#     vm_platform_id = "standard-v3"
#     vm_cpu = 2
#     vm_ram = 2
#     vm_user = "centos"
#     subnet_id = module.net.subnet_id
#     nat_ip = false
# }

# module "vpc-2" {
#     source = "./modules/vpc"
#     vm_zone = "ru-central1-a"
#     vm_guest = "centos-7"
#     vm_ssh_public_key = "~/.ssh/id_ed25519.pub"
#     // Параметры диска
#     disk_name = "vm-1-disk"
#     disk_type = "network-hdd"
#     disk_size = 25
#     // Параметры ВМ
#     vm_name = "gfs-node-1"
#     vm_hostname = "gfs1"
#     vm_platform_id = "standard-v3"
#     vm_cpu = 2
#     vm_ram = 2
#     vm_user = "centos"
#     subnet_id = module.net.subnet_id
#     nat_ip = false
# }

# module "vpc-3" {
#     source = "./modules/vpc"
#     vm_zone = "ru-central1-a"
#     vm_guest = "centos-7"
#     vm_ssh_public_key = "~/.ssh/id_ed25519.pub"
#     // Параметры диска
#     disk_name = "vm-2-disk"
#     disk_type = "network-hdd"
#     disk_size = 25
#     // Параметры ВМ
#     vm_name = "gfs-node-2"
#     vm_hostname = "gfs2"
#     vm_platform_id = "standard-v3"
#     vm_cpu = 2
#     vm_ram = 2
#     vm_user = "centos"
#     subnet_id = module.net.subnet_id
#     nat_ip = false
# }

# module "vpc-4" {
#     source = "./modules/vpc"
#     vm_zone = "ru-central1-a"
#     vm_guest = "centos-7"
#     vm_ssh_public_key = "~/.ssh/id_ed25519.pub"
#     // Параметры диска
#     disk_name = "vm-3-disk"
#     disk_type = "network-hdd"
#     disk_size = 25
#     // Параметры ВМ
#     vm_name = "gfs-node-3"
#     vm_hostname = "gfs3"
#     vm_platform_id = "standard-v3"
#     vm_cpu = 2
#     vm_ram = 2
#     vm_user = "centos"
#     subnet_id = module.net.subnet_id
#     nat_ip = false
# }


# output "vpc_1_ssh_user" {
#   value = module.vpc-1.ssh_user
# }

# output "vpc_1_ssh_command" {
#   value = module.vpc-1.ssh_connection_string
# }

# # Для всех ВМ сразу
# output "all_ssh_connections" {
#   description = "SSH commands for all instances"
#   value = {
#     vpc-1 = module.vpc-1.ssh_connection_string
#     vpc-2 = module.vpc-2.ssh_connection_string
#     vpc-3 = module.vpc-3.ssh_connection_string
#     vpc-4 = module.vpc-4.ssh_connection_string
#   }
#   sensitive = false
# }