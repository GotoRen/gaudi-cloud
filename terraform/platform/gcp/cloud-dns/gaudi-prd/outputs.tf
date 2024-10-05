output "gaudi_ren510_dev_id" {
  value       = google_dns_managed_zone.gaudi_ren510_dev.id
  description = "The ID of the managed zone"
}

output "gaudi_ren510_dev_dns_name" {
  value       = google_dns_managed_zone.gaudi_ren510_dev.dns_name
  description = "The DNS name of the managed zone"
}

output "gaudi_ren510_dev_managed_zone_id" {
  value       = google_dns_managed_zone.gaudi_ren510_dev.managed_zone_id
  description = "The managed zone ID"
}

output "gaudi_ren510_dev_name_servers" {
  value       = google_dns_managed_zone.gaudi_ren510_dev.name_servers
  description = "The name servers of the managed zone"
}
