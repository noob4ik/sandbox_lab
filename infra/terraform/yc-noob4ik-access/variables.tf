variable "cloud_id" {
  description = "Yandex Cloud cloud ID (noob4ik-sandbox)"
  type        = string
  default     = "b1gr6l37afpf886jucaj"
}

variable "access_folder_name" {
  description = "Name of the service folder that holds access management resources"
  type        = string
  default     = "access"
}

variable "tf_sa_name" {
  description = "Name of the Terraform runner service account"
  type        = string
  default     = "sa-terraform"
}

variable "tf_state_bucket" {
  description = "Object Storage bucket name for Terraform state (must be globally unique)"
  type        = string
  default     = "noob4ik-sandbox-tfstate"
}
