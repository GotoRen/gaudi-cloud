// private node の pod IP から VPC 内への通信を許可するために必要
// GKE pod IP range を追加したら source_ranges に追記する必要がある
// asia-northeast1 用 FW
resource "google_compute_firewall" "pod-to-node" {
  project = local.project_id
  name    = "${local.name}-allow-pod-to-node"
  network = local.name

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
    "10.226.0.0/18", # gke-gaudi-tky-prd-pods
  ]
}

// 内部通信の許可
resource "google_compute_firewall" "allow-internal-traffic" {
  project = local.project_id
  name    = "gaudi-prd-allow-internal-traffic"
  network = local.name

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
    "10.0.0.0/8"
  ]
}

// HTTP トラフィックの許可
resource "google_compute_firewall" "allow-http-external" {
  project = local.project_id
  name    = "gaudi-prd-allow-http-external"
  network = local.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]
}
