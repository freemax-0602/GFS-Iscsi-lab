/*
==================================================
============= Описание ВМ ========================
==================================================
*/
variable "vm_name" {
  description = "Имя ВМ"
  type        = string
}

variable "vm_hostname" {
  description = "Hostname VM"
  type        = string
}

variable "vm_ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "vm_platform_id" {
  description = "Имя идентификатора платформы ВМ"
  type        = string
}

variable "vm_zone" {
  description = "Зона доступности VM"
  type        = string
}

variable "vm_cpu" {
  description = "Количество ядер процессора"
  type        = number
}

variable "vm_ram" {
  description = "Размер ОЗУ ВМ"
  type        = number
}
/*
==================================================
============= Описание дисков ВМ =================
==================================================
*/
variable "disk_name" {
  description = "Имя диска на ВМ"
  type        = string
}

variable "disk_type" {
  description = "Тип используемого диска"
  type        = string
}

variable "disk_size" {
  description = "Размер диска"
  type        = number
}