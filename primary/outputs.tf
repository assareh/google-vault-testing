output "primary_lb_address" {
  value = "https://${module.vault.lb_address}/"
}

output "ssh_command" {
  value = "gcloud compute ssh --project ${var.project_id}"
}

# port forward