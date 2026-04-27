
# Инциализация провайдера Ycloud
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

}

# Провайдер yandex по умолчанию (зона доступности ru-central-b)
provider "yandex" {
  token = "y0__xCivdNrGMHdEyD26-ycFHJtujA-g_jF-B7gylu-R_VCzu5r"
  folder_id = "b1gkiafie74e9a5f3et3"
  zone = "ru-central1-a"
}