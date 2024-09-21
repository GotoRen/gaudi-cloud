/******************************************
	VPC configuration
 *****************************************/
resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
  project                 = var.project_id
}

/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "subnetwork" {
  count = length(var.subnets)

  name = lookup(var.subnets[count.index], "name")

  project = var.project_id
  region  = lookup(var.subnets[count.index], "region")
  network = google_compute_network.network.self_link

  private_ip_google_access = lookup(var.subnets[count.index], "private_ip_google_access", "false")
  ip_cidr_range            = lookup(var.subnets[count.index], "ip_cidr_range")

  dynamic "log_config" {
    for_each = lookup(var.subnets[count.index], "log_config") == null ? [] : list(lookup(var.subnets[count.index], "log_config"))

    content {
      aggregation_interval = log_config.value["aggregation_interval"]
      flow_sampling        = log_config.value["flow_sampling"]
      metadata             = log_config.value["metadata"]
    }
  }

  dynamic "secondary_ip_range" {
    for_each = lookup(var.subnets[count.index], "secondary_ip_ranges", [])

    content {
      range_name    = secondary_ip_range.value["range_name"]
      ip_cidr_range = secondary_ip_range.value["ip_cidr_range"]
    }
  }
}

data "google_compute_subnetwork" "created_subnets" {
  count = length(var.subnets)

  name    = element(google_compute_subnetwork.subnetwork.*.name, count.index)
  region  = element(google_compute_subnetwork.subnetwork.*.region, count.index)
  project = var.project_id

  depends_on = [google_compute_subnetwork.subnetwork]
}
