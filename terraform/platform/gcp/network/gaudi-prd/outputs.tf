output "network_name" {
  value       = module.network.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.network.network_self_link
  description = "The URI of the VPC being created"
}

output "subnetworks" {
  value       = module.network.subnetworks
  description = "The subnets being created"
}

output "subnets_names" {
  value       = module.network.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = module.network.subnets_ips
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_self_links" {
  value       = module.network.subnets_self_links
  description = "The self-links of subnets being created"
}

output "subnets_regions" {
  value       = module.network.subnets_regions
  description = "The region where the subnets will be created"
}

output "subnets_private_access" {
  value       = module.network.subnets_private_access
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "subnets_secondary_ranges" {
  value       = module.network.subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}
