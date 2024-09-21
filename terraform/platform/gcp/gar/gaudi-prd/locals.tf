locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "cloud-platform"
  env        = "prd"
}

locals {
  registries = [
    {
      name        = "gaudi-prd-backend"
      description = "Backend repository for gaudi prd"
    },
    {
      name        = "gaudi-prd-frontend"
      description = "Frontend repository for gaudi prd"
    },
  ]
}
