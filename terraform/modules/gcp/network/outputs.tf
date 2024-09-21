output "network_id" {
  value       = google_compute_network.network.id
  description = "The ID of the VPC being created"
}

output "network_name" {
  value       = google_compute_network.network.name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.network.self_link
  description = "The URI of the VPC being created"
}

output "subnetworks" {
  value       = google_compute_subnetwork.subnetwork
  description = "The subnets being created"
}

output "subnets_names" {
  value       = google_compute_subnetwork.subnetwork.*.name
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = google_compute_subnetwork.subnetwork.*.ip_cidr_range
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_self_links" {
  value       = google_compute_subnetwork.subnetwork.*.self_link
  description = "The self-links of subnets being created"
}

output "subnets_regions" {
  value       = google_compute_subnetwork.subnetwork.*.region
  description = "The region where the subnets will be created"
}

output "subnets_private_access" {
  value       = google_compute_subnetwork.subnetwork.*.private_ip_google_access
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "subnets_secondary_ranges" {
  value       = data.google_compute_subnetwork.created_subnets.*.secondary_ip_range
  description = "The secondary ranges associated with these subnets"
}
