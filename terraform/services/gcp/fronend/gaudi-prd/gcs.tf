resource "google_storage_bucket" "gaudi_prd_frontend" {
  name                        = "gaudi-prd-frontend"
  location                    = local.region
  storage_class               = "STANDARD" # STANDARD / MULTI_REGIONAL / REGIONAL / NEARLINE / COLDLINE / ARCHIVE
  uniform_bucket_level_access = true

  soft_delete_policy {
    retention_duration_seconds = 0 // disable soft delete polciy because no need to recover profile data.
  }

  labels = merge(
    module.resource_labels.labels,
    {
      resource-name = "gaudi-prd-frontend"
    },
  )
}
