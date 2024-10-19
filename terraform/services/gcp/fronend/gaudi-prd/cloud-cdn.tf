// CDN Backend Bucket
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

// CDN 署名付き URL
resource "random_id" "url_signature" {
  byte_length = 16
}

resource "google_compute_backend_bucket_signed_url_key" "backend_key" {
  project        = local.project_id
  name           = "public-backend-bucket-key"
  key_value      = random_id.url_signature.b64_url
  backend_bucket = google_compute_backend_bucket.cdn_backend.name
}

// URL マップ
resource "google_compute_url_map" "https" {
  name            = "${local.name}-https"
  default_service = google_compute_backend_bucket.cdn_backend.self_link
}

// ターゲット HTTP プロキシ
resource "google_compute_target_http_proxy" "cdn_http_proxy" {
  name    = local.name
  url_map = google_compute_url_map.https.id
}

// フォワーディングルール
resource "google_compute_global_forwarding_rule" "cdn_forwarding_rule" {
  name       = "${local.name}-https"
  target     = google_compute_target_http_proxy.cdn_http_proxy.id
  port_range = "80"
}
