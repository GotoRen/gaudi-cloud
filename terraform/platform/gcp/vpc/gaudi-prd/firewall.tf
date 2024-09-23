// プライベートサブネットノード の Pod から VPC 内への Egress 通信を許可
resource "google_compute_firewall" "pod-to-node" {
  project = local.project_id
  name    = "${local.network_name}-allow-pod-to-node"
  network = local.network_name

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    local.subnetwork_ranges.gke_gaudi_prd_pod # 10.16.0.0/12
  ]
}

// VPC サブネットの内部通信を全て許可
resource "google_compute_firewall" "allow-internal-traffic" {
  project = local.project_id
  name    = "${local.network_name}-allow-internal-traffic"
  network = local.network_name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    local.subnetwork_ranges.gke_gaudi_prd_subnet # 10.0.0.0/20
  ]
}

// 外部からの HTTP 通信を許可
resource "google_compute_firewall" "allow-http-external" {
  project = local.project_id
  name    = "${local.network_name}-allow-http-external"
  network = local.network_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]
}
