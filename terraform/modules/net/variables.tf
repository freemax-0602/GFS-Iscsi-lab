variable "net_name" {
  type = string
  default = "network-1"
}

variable "netowrk_description" {
  type = string
  default = "My net"
}

variable "subnet_name" {
  type = string
  default = "subnet-1"
}

variable "subnet_description" {
  type = string
  default = "My subnet"
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.2.0.0/16"]
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}