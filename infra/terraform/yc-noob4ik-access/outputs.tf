output "access_folder_id" {
  description = "ID of the service 'access' folder"
  value       = yandex_resourcemanager_folder.access.id
}

output "terraform_sa_id" {
  description = "ID of the Terraform runner service account"
  value       = yandex_iam_service_account.terraform.id
}

output "s3_access_key" {
  description = "Static access key ID for S3 backend"
  value       = yandex_iam_service_account_static_access_key.terraform_s3.access_key
  sensitive   = true
}

output "s3_secret_key" {
  description = "Static secret key for S3 backend"
  value       = yandex_iam_service_account_static_access_key.terraform_s3.secret_key
  sensitive   = true
}

output "tfstate_bucket" {
  description = "Bucket name for Terraform remote state"
  value       = yandex_storage_bucket.tfstate.bucket
}

output "backend_snippet" {
  description = "Paste into backend.tf of each workspace (change the key path)"
  value       = <<-EOT
    terraform {
      backend "s3" {
        endpoint = "https://storage.yandexcloud.net"
        bucket   = "${yandex_storage_bucket.tfstate.bucket}"
        region   = "ru-central1"
        key      = "<workspace>/terraform.tfstate"

        skip_region_validation      = true
        skip_credentials_validation = true
      }
    }
    # Export before terraform init:
    # export AWS_ACCESS_KEY_ID=<s3_access_key>
    # export AWS_SECRET_ACCESS_KEY=<s3_secret_key>
  EOT
}
