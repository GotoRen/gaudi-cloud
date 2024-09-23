
locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "native"
  env        = "prd"
}

locals {
  service_account_name = "gaudi-frontend-sa"
}
