provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# primary
module "prereqs_quickstart" {
  source = "github.com/assareh/terraform-gcp-vault-ent-starter//examples/prereqs_quickstart"

  network_name = var.network_name
  project_id   = var.project_id
  region       = var.region
}

# secondary
module "test_vpc_module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.2.0"
  project_id   = var.project_id
  network_name = var.network_name_secondary

  subnets = [
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = var.region
    }
  ]
}

#NAT router
resource "google_compute_router" "vault_router" {
  name    = "vault-router-2"
  project = var.project_id
  region  = var.region
  network = module.test_vpc_module.network_name
}

# NAT service
resource "google_compute_router_nat" "vault_nat" {
  name    = "vault-nat-2"
  project = var.project_id
  router  = google_compute_router.vault_router.name
  region  = var.region

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# peering
module "peeringAB" {
  source = "git::https://gitlab.developers.cam.ac.uk/uis/devops/infra/terraform/gcp-vpc-peering.git"

  project        = var.project_id
  peered_project = var.project_id

  network_name = var.network_name
  network_link = module.prereqs_quickstart.network

  peered_network_name = var.network_name_secondary
  peered_network_link = module.test_vpc_module.network_self_link

  network_route_mode        = "import"
  peered_network_route_mode = "export"

  inbound_peering_name  = var.network_name
  outbound_peering_name = var.network_name_secondary
}

# firewall rules
resource "google_compute_firewall" "secondary_to_primary" {
  name    = "secondary-to-primary"
  network = module.prereqs_quickstart.network

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8200-8201"]
  }

  source_ranges = ["10.10.20.0/24"]
}

resource "google_compute_firewall" "primary_to_secondary" {
  name    = "primary-to-secondary"
  network = module.test_vpc_module.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8200-8201"]
  }

  source_ranges = ["10.10.10.0/24"]
}
