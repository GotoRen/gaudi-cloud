resource "google_artifact_registry_repository" "gaudi_prd_registries" {
  for_each = { for repo in local.registries : repo.name => repo }

  location      = local.region
  repository_id = each.key
  description   = each.value.description
  format        = "DOCKER"

  labels = merge(
    module.resource_labels.labels, {
      "resource-name" = each.key
    }
  )
}
