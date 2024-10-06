locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "cloud-platform"
  env        = "prd"
}

locals {
  service_account_name = "external-dns"
  namespace_name       = "external-dns"
  ksa_name             = "external-dns"
}
