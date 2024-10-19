output "bucket_name" {
  value = google_storage_bucket.gaudi_prd_frontend.name
}

output "cdn_url" {
  value = google_compute_global_forwarding_rule.cdn_forwarding_rule.self_link
}
