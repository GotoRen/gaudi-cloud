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

  ### Quota Limit ###
  # - CPUs (All Regions): 32 vCPU まで
  # - CPUs (Regional): 24 vCPU まで
  # - SSD Total GB: 500GB まで
  # refs: https://cloud.google.com/compute/docs/general-purpose-machines#e2-standard
  machine_type   = "e2-standard-4" # 4vCPU / 16GB
  min_node_count = 1               # ゾーンあたりのノードの最小数
  max_node_count = 3               # ゾーンあたりのノードの最大数
}
