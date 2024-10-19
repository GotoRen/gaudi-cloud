// Create a bucket for frontend
resource "google_storage_bucket" "gaudi_prd_frontend" {
  name                        = local.name
  location                    = local.region
  storage_class               = "STANDARD" # STANDARD / MULTI_REGIONAL / REGIONAL / NEARLINE / COLDLINE / ARCHIVE
  uniform_bucket_level_access = false

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

// バケットを公開する場合
resource "google_storage_bucket_iam_binding" "public_access" {
  bucket  = google_storage_bucket.gaudi_prd_frontend.name
  role    = "roles/storage.objectViewer"
  members = ["allUsers"] // 全てのユーザを対象としてバケットを公開
}
