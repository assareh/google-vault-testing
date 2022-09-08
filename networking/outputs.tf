output "leader_tls_servername" {
  value       = module.prereqs_quickstart.leader_tls_servername
  description = "Shared SAN that will be given to the Vault nodes configuration for use as leader_tls_servername"
}

output "ssl_certificate_name" {
  value       = module.prereqs_quickstart.ssl_certificate_name
  description = "Name of the ssl certificate resource"
}

output "subnetwork" {
  value       = module.prereqs_quickstart.subnetwork
  description = "The self-link of subnet being created"
}

output "subnetwork_secondary" {
  value       = join("", module.test_vpc_module.subnets_self_links[*])
  description = "The self-link of subnet being created"
}

output "tls_secret_id" {
  value       = module.prereqs_quickstart.tls_secret_id
  description = "Secret id/name given to the Google Secret Manager secret"
}