locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "cloud-platform"
  env        = "prd"
}

locals {
  name      = "gaudi-prd"
  subnet_01 = "${local.name}-asia-northeast1-01"
}
