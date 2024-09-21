locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "cloud-platform"
  group      = "gke"
  env        = "prd"
}

locals {
  cluster_name    = "gaudi-tky-prd"
  cluster_version = "1.29.8-gke.1031000"

  cluster_autoscaling = {
    enabled             = false
    auto_upgrade        = false
    auto_repair         = true
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
    max_cpu_cores       = 0
    min_cpu_cores       = 0
    max_memory_gb       = 0
    min_memory_gb       = 0
    gpu_resources       = []
  }
}

locals {
  subnets_secondary_ranges = flatten(data.terraform_remote_state.network.outputs.subnets_secondary_ranges)
}
