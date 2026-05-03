resource "yandex_iam_service_account" "sa" {
  name        = var.serviceAccount_Name
  description = var.serviceAccount_Description
  folder_id   = var.serviceAccount_folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "admin-account-iam" {
  folder_id   = var.serviceAccount_folder_id
  role        = var.serviceAccount_role
  member      = "serviceAccount:${yandex_iam_service_account.sa.id}"
}