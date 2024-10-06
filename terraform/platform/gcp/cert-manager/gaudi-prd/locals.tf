locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "cloud-platform"
  env        = "prd"
}

locals {
  service_account_name = "cert-manager"
  namespace_name       = "cert-manager"
  ksa_name             = "cert-manager"
}
