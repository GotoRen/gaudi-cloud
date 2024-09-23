locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "cloud-platform"
  env        = "prd"
}

locals {
  service_account_name = "gaudi-backend-sa"
  namespace_name       = "gaudi-backend"
  ksa_name             = "gaudi-backend-ksa"
}
