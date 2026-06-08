# --- Service folder for access management resources ---

resource "yandex_resourcemanager_folder" "access" {
  cloud_id    = var.cloud_id
  name        = var.access_folder_name
  description = "Service folder: access management, SA, Terraform state"
}

# --- Terraform runner service account (lives in the access folder) ---

resource "yandex_iam_service_account" "terraform" {
  folder_id   = yandex_resourcemanager_folder.access.id
  name        = var.tf_sa_name
  description = "Terraform runner — manages all folders under noob4ik-sandbox"
}

# editor at cloud level — covers all current and future folders
resource "yandex_resourcemanager_cloud_iam_member" "terraform_editor" {
  cloud_id = var.cloud_id
  role     = "editor"
  member   = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

# Allowed to grant/revoke roles within the cloud (needed to manage IAM bindings via TF)
resource "yandex_resourcemanager_cloud_iam_member" "terraform_iam_admin" {
  cloud_id = var.cloud_id
  role     = "resource-manager.admin"
  member   = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

# --- Static key for S3-compatible backend ---

resource "yandex_iam_service_account_static_access_key" "terraform_s3" {
  service_account_id = yandex_iam_service_account.terraform.id
  description        = "S3 static key for Terraform remote state backend"
}

# storage.admin scoped to the access folder only (principle of least privilege for the bucket)
resource "yandex_resourcemanager_folder_iam_member" "terraform_storage_admin" {
  folder_id = yandex_resourcemanager_folder.access.id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

# --- Object Storage bucket for Terraform state ---

resource "yandex_storage_bucket" "tfstate" {
  bucket     = var.tf_state_bucket
  folder_id  = yandex_resourcemanager_folder.access.id
  access_key = yandex_iam_service_account_static_access_key.terraform_s3.access_key
  secret_key = yandex_iam_service_account_static_access_key.terraform_s3.secret_key

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}
