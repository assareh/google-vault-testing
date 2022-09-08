provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "tfe" {
}

data "tfe_outputs" "prereqs_quickstart" {
  organization = var.prereqs_quickstart_organization
  workspace    = var.prereqs_quickstart_workspace
}

module "vault" {
  source = "github.com/assareh/terraform-gcp-vault-ent-starter"

  # The shared DNS SAN of the TLS certs being used
  leader_tls_servername = data.tfe_outputs.prereqs_quickstart.values.leader_tls_servername
  # Your GCP project ID
  project_id = var.project_id
  # Prefix for uniquely identifying GCP resources
  resource_name_prefix = "vault-primary"
  # Self link of the subnetwork you wish to deploy into
  subnetwork = data.tfe_outputs.prereqs_quickstart.values.subnetwork
  # Name of the SSL Certificate to be used for Vault LB
  ssl_certificate_name = data.tfe_outputs.prereqs_quickstart.values.ssl_certificate_name
  # Secret id/name given to the google secret manager secret
  tls_secret_id = data.tfe_outputs.prereqs_quickstart.values.tls_secret_id
  # Enterprise license
  vault_license = var.vault_license
  # Upgrades
  vault_version = "1.11.2"
  node_count    = "5"
}
