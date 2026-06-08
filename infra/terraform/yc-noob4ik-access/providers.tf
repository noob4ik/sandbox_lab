terraform {
  required_version = ">= 1.3"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100"
    }
  }
}

# No folder_id at provider level — each resource specifies its own folder
provider "yandex" {
  cloud_id = var.cloud_id
}
