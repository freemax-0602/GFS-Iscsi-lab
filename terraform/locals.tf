locals{
  all_instances = [
    {
      name       = module.vpc-1.vm_name
      public_ip  = module.vpc-1.public_ip_vm
      private_ip = module.vpc-1.private_ip_vm
    },
    {
      name       = module.vpc-2.vm_name
      public_ip  = module.vpc-2.public_ip_vm
      private_ip = module.vpc-2.private_ip_vm
    },
    {
      name       = module.vpc-3.vm_name
      public_ip  = module.vpc-3.public_ip_vm
      private_ip = module.vpc-3.private_ip_vm
    },
    {
      name       = module.vpc-4.vm_name
      public_ip  = module.vpc-4.public_ip_vm
      private_ip = module.vpc-4.private_ip_vm
    },
  ]
}