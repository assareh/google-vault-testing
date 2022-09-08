variable "network_name" {
  type        = string
  description = "VPC Network name"
  default     = "vault-primary"
}

variable "network_name_secondary" {
  type        = string
  description = "VPC Network name"
  default     = "vault-secondary"
}

variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "GCP region in which to launch resources"
  default     = "us-west1"
}
