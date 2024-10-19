// Create a backend bucket for CDN
resource "google_compute_backend_bucket" "cdn_backend" {
  name        = "${local.name}-cdn-backend"
  description = "${local.name} backend bucket for CDN"
  bucket_name = google_storage_bucket.gaudi_prd_frontend.name
  enable_cdn  = true
  cdn_policy {
    cache_mode         = "CACHE_ALL_STATIC"
    default_ttl        = 86400
    request_coalescing = true
    client_ttl         = 86400
  }
}

// Create URL map
resource "google_compute_url_map" "https" {
  name            = "${local.name}-https"
  default_service = google_compute_backend_bucket.cdn_backend.self_link
}

// Create target HTTP proxy
resource "google_compute_target_http_proxy" "cdn_http_proxy" {
  name    = local.name
  url_map = google_compute_url_map.https.id
}

// Create global forwarding rule
resource "google_compute_global_forwarding_rule" "cdn_forwarding_rule" {
  name       = "${local.name}-https"
  target     = google_compute_target_http_proxy.cdn_http_proxy.id
  port_range = "80"
}
