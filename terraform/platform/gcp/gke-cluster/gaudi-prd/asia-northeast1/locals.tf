locals {
  project_id = "gcp-gaudi-prd"
  region     = "asia-northeast1"
  owner      = "cloud-platform"
  group      = "gke"
  env        = "prd"
}

locals {
  cluster_name    = "gaudi-tky-prd"
  cluster_version = "1.30.4-gke.1348000"

  node_locations = [
    "asia-northeast1-a",
    "asia-northeast1-b",
    "asia-northeast1-c"
  ]

  ### Quota Limit ###
  # - CPUs (All Regions): 32 vCPU まで
  # - CPUs (Regional): 24 vCPU まで
  # - SSD Total GB: 500GB まで
  # refs: https://cloud.google.com/compute/docs/general-purpose-machines#e2-standard
  machine_type   = "e2-standard-2" # 2vCPU / 8GB
  min_node_count = 1               # ゾーンあたりのノードの最小数
  max_node_count = 3               # ゾーンあたりのノードの最大数
}
