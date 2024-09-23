/*************************************************
  VPC configuration for GKE (Private Network)
 *************************************************/
resource "google_compute_network" "gke_gaudi_vpc_network" {
  project                 = local.project_id
  name                    = local.network_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "gke_gaudi_vpc_subnetwork" {
  project       = local.project_id
  name          = "${local.network_name}-${local.region}-01"
  network       = google_compute_network.gke_gaudi_vpc_network.id
  ip_cidr_range = local.subnetwork_ranges["gke_gaudi_prd_subnet"] # 10.0.0.0/20

  private_ip_google_access = true # VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.

  # https://cloud.google.com/vpc/docs/flow-logs#filtering
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 1
    metadata             = "INCLUDE_ALL_METADATA" # VPC Flow ログを出力
    filter_expr          = "true"                 # used CEL (Common Expression Language)
  }

  # Secondary IPv4 range
  secondary_ip_range {
    range_name    = local.gke_gaudi_prd.cluster_secondary_range_name # GKE Pod IP range
    ip_cidr_range = local.subnetwork_ranges["gke_gaudi_prd_pod"]     # 10.16.0.0/12
  }

  secondary_ip_range {
    range_name    = local.gke_gaudi_prd.services_secondary_range_name # GKE Service IP range
    ip_cidr_range = local.subnetwork_ranges["gke_gaudi_prd_service"]  # 10.1.0.0/20
  }

  depends_on = [
    google_compute_network.gke_gaudi_vpc_network
  ]
}
