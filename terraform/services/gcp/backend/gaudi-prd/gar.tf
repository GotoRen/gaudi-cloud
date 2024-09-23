resource "google_artifact_registry_repository" "gaudi_prd_backend_artifact_registry" {
  repository_id = "gaudi-prd-backend"
  description   = "Artifact Registry for gaudi-backend"
  location      = local.region
  format        = "DOCKER"

  labels = merge(
    module.resource_labels.labels, {
      "resource-name" = "gaudi-prd-backend"
    }
  )
}
