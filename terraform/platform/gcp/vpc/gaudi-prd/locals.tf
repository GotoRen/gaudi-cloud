locals {
  project_id   = "gcp-gaudi-prd"
  region       = "asia-northeast1"
  owner        = "cloud-platform"
  group        = "networking"
  subgroup     = "gke"
  env          = "prd"
  network_name = "gaudi-prd"
}

locals {
  subnetwork_ranges = {
    gke_gaudi_prd_subnet  = "10.0.0.0/20"  # 10.0.0.1 - 10.0.15.254 (4,094 IP addresses)
    gke_gaudi_prd_pod     = "10.16.0.0/12" # 10.16.0.1 - 10.31.255.254 (1,048,574 IP addresses)
    gke_gaudi_prd_service = "10.1.0.0/20"  # 10.1.0.1 - 10.1.15.254 (4,094 IP addresses)
  }

  gke_gaudi_prd = {
    cluster_secondary_range_name  = "gke-gaudi-prd-pods"
    services_secondary_range_name = "gke-gaudi-prd-services"
  }
}
