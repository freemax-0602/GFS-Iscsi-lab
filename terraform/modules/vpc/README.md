# simple-vm

Модуль для создания виртуальной машины в Yandex Cloud.

## Пример использования

```hcl
module "web_vm" {
  source     = "./modules/simple-vm"
  name       = "web-01"
  subnet_id  = data.yandex_vpc_subnet.default.id
}