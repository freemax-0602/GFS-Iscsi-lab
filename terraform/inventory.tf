# outputs.tf или inventory.tf
# resource "local_file" "inventory" {
  
#   filename = "../ansible/inventories/inventory.yml"
  
#   content = templatefile("./inventory.tfpl", {
#     instances = local.all_instances
#     ssh_key   = pathexpand("~/.ssh/id_ed25519")  
#     vps_user  = "centos"
#   })

#   lifecycle {
#     ignore_changes = [content]
#   }
# }