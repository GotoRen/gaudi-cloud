
locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "native"
  env        = "prd"
}

locals {
  name                 = "gaudi-prd-frontend"
  service_account_name = "gaudi-frontend-sa"
}
