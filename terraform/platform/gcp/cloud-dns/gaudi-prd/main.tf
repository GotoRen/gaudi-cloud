resource "google_dns_managed_zone" "gaudi_ren510_dev" {
  name        = "gaudi-ren510-dev"
  dns_name    = "gaudi.ren510.dev."
  description = "gaudi.ren510.dev DNS Zone"
  visibility  = "public"

  cloud_logging_config {
    enable_logging = true
  }

  labels = merge(
    module.resource_labels.labels,
    {
      "resource-name"     = "gaudi-ren510-dev"
      "resource-group"    = local.group
      "resource-subgroup" = local.subgroup
    },
  )
}
