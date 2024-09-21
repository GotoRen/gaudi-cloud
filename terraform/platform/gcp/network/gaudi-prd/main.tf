/******************************************
	VPC configuration
 *****************************************/
module "network" {
  source       = "../../../../modules/gcp/network"
  project_id   = local.project_id
  network_name = local.name

  # サブネットの作成
  subnets = [
    {
      name                     = local.subnet_01
      ip_cidr_range            = "10.226.128.0/20"
      region                   = "asia-northeast1"
      private_ip_google_access = true
      log_config               = null
      secondary_ip_ranges = [
        {
          ip_cidr_range = "10.226.96.0/19"
          range_name    = "gke-gaudi-tky-prd-pods"
        },
        {
          ip_cidr_range = "10.226.160.0/20"
          range_name    = "gke-gaudi-tky-prd-services"
        }
      ]

      labels = merge(
        module.resource_labels.labels, {
          "resource-name"     = local.subnet_01
          "resource-group"    = "networking"
          "resource-subgroup" = "vpc"
        }
      )
    },
  ]
}

/******************************************
	Service Networkling configuration
 *****************************************/
resource "google_service_networking_connection" "private_service_connection" {
  network = module.network.network_id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.service_range.name,
  ]
}

/******************************************
	Global IP Address configuration
 *****************************************/
resource "google_compute_global_address" "service_range" {
  name          = "google-managed-services-${local.name}"
  purpose       = "VPC_PEERING"
  network       = module.network.network_id
  address_type  = "INTERNAL"
  address       = "10.241.0.0"
  prefix_length = 16

  labels = merge(
    module.resource_labels.labels, {
      "resource-name"     = "google-managed-services-${local.name}"
      "resource-group"    = "networking"
      "resource-subgroup" = "global-ip-address"
    }
  )
}
