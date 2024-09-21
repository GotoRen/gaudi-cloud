resource "google_compute_firewall" "allow-internal" {
  name    = "${google_compute_network.network.name}-allow-internal"
  network = google_compute_network.network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  source_ranges = google_compute_subnetwork.subnetwork.*.ip_cidr_range

  depends_on = [google_compute_subnetwork.subnetwork]
}
