resource "google_spanner_instance" "prd_spanner" {
  name         = local.name
  config       = "regional-asia-northeast1"
  display_name = "Shared Storage for Production"
  num_nodes    = 1

  labels = merge(
    module.resource_labels.labels,
    {
      "resource-name"     = local.name
      "resource-group"    = local.group
      "resource-subgroup" = local.subgroup
    },
  )
}

resource "google_spanner_database" "gaudi" {
  instance                 = google_spanner_instance.prd_spanner.name
  name                     = "gaudi"
  version_retention_period = "7d"
  deletion_protection      = false
}
