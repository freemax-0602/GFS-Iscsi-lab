variable "serviceAccount_Name" {
  type = string
  description = "service account name"
}

variable "serviceAccount_Description" {
  type = string
  description = "service account description"
}

variable "serviceAccount_folder_id" {
  type = string
  description = "forlder_id for Service Account"
}

variable "serviceAccount_role" {
  type = string
  description = "service account roles (admin, editor, viewer, auditor)"
}
