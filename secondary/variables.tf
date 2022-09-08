variable "prereqs_quickstart_organization" {
  type        = string
  description = "Terraform organization to read VPC inputs from"
}

variable "prereqs_quickstart_workspace" {
  type        = string
  description = "Terraform workspace to read VPC inputs from"
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

variable "vault_license" {
  type        = string
  description = "The Vault license"
  default     = ""
}
