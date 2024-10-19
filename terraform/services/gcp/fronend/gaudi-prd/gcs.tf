// GCS Bucket for Frontend
resource "google_storage_bucket" "gaudi_prd_frontend" {
  name                        = local.name
  location                    = local.region
  storage_class               = "STANDARD" # STANDARD / MULTI_REGIONAL / REGIONAL / NEARLINE / COLDLINE / ARCHIVE
  uniform_bucket_level_access = true

  public_access_prevention = "inherited"

  soft_delete_policy {
    retention_duration_seconds = 0 // disable soft delete polciy because no need to recover profile data.
  }

  force_destroy = true // delete all objects in the bucket when the bucket is deleted

  labels = merge(
    module.resource_labels.labels,
    {
      resource-name = local.name
    },
  )
}

// Cloud CDN GSA からのアクセスを許可
resource "google_storage_bucket_iam_member" "signed_url_access" {
  bucket = google_storage_bucket.gaudi_prd_frontend.name
  member = "serviceAccount:service-99675137911@cloud-cdn-fill.iam.gserviceaccount.com" // Cloud CDN GSA
  for_each = toset([
    "roles/storage.objectViewer",
  ])
  role = each.value

  depends_on = [
    google_compute_backend_bucket_signed_url_key.backend_key
  ]
}
