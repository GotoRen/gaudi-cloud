module "gke" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/beta-public-cluster?ref=v29.0.0"
  providers = {
    google = google
  }

  name       = local.cluster_name
  project_id = local.project_id

  cluster_resource_labels = merge(
    module.resource_labels.labels,
    {
      "resource-name"     = local.cluster_name,
      "resource-group"    = local.group,
      "resource-subgroup" = local.cluster_name,
    },
  )

  region     = local.region
  network    = data.terraform_remote_state.network.outputs.network_name
  subnetwork = data.terraform_remote_state.network.outputs.subnets_names[0]

  service_account = "gke-service-account@${local.project_id}.iam.gserviceaccount.com"
  # authenticator_security_group = "gke-security-groups@yourdomain.com"
  kubernetes_version                  = local.cluster_version # Control Plane version
  deletion_protection                 = false
  release_channel                     = "UNSPECIFIED"
  disable_default_snat                = false # disable = false
  logging_service                     = "logging.googleapis.com/kubernetes"
  monitoring_service                  = "monitoring.googleapis.com/kubernetes"
  logging_enabled_components          = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  monitoring_enabled_components       = ["APISERVER", "CONTROLLER_MANAGER", "SCHEDULER", "SYSTEM_COMPONENTS"]
  cluster_autoscaling                 = local.cluster_autoscaling
  enable_l4_ilb_subsetting            = false
  default_max_pods_per_node           = 32
  enable_shielded_nodes               = true
  issue_client_certificate            = false
  enable_pod_security_policy          = false
  workload_config_audit_mode          = "DISABLED"
  enable_mesh_certificates            = false # Controls the issuance of workload mTLS certificates. When enabled the GKE Workload Identity Certificates controller and node agent will be deployed in the cluster. Requires Workload Identity.
  security_posture_mode               = "DISABLED"
  security_posture_vulnerability_mode = "VULNERABILITY_BASIC"
  enable_gcfs                         = false # default: false , gcsf = image streaming , node pool 単位でも設定可能

  # addons config
  http_load_balancing                  = true
  horizontal_pod_autoscaling           = true
  enable_vertical_pod_autoscaling      = true
  network_policy                       = false
  istio                                = false
  cloudrun                             = false
  dns_cache                            = true
  gce_pd_csi_driver                    = true
  kalm_config                          = false
  config_connector                     = false
  monitoring_enable_managed_prometheus = true
  enable_cost_allocation               = true

  ip_range_pods     = local.subnets_secondary_ranges[0].range_name # gke-gaudi-tky-prd-pods
  ip_range_services = local.subnets_secondary_ranges[1].range_name # gke-gaudi-tky-prd-services

  maintenance_start_time = "02:00" # 外せないので UTC 02:00 にしてお昼前に実行されるようにする

  initial_node_count = 1

  remove_default_node_pool = true

  create_service_account            = false
  disable_legacy_metadata_endpoints = true
  node_metadata                     = "GKE_METADATA_SERVER"

  node_pools = [
    // https://cloud.google.com/compute/docs/general-purpose-machines#n2-standard
    // - n2-standard-16 is 16 vCPU / 64 GB Memory
    {
      name               = "gaudi-tky-prd-node-pool"
      machine_type       = "e2-highcpu-2"
      version            = local.cluster_version
      disk_size_gb       = 50
      disk_type          = "pd-balanced"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = false
      spot               = false                                        # Preemptible VM を利用
      pod_range          = local.subnets_secondary_ranges[0].range_name # gke-gaudi-tky-prd-pods
      initial_node_count = 0
      max_pods_per_node  = 64
      autoscaling        = true
      node_count         = 3
      min_count          = 3
      max_count          = 20
    }
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/userinfo.email",
    ]
  }

  node_pools_metadata = {
    all = {
      disable-legacy-endpoints = "true"
      cluster_name             = local.cluster_name
    }
    gaudi-tky-prd-node-pool = {
      type = "gaudi-tky-prd-node-pool"
    }
  }

  // node 自体にラベルを付けるにはこのオプションが必要
  node_pools_resource_labels = {
    all = {}
    gaudi-tky-prd-node-pool = merge(
      module.resource_labels.labels,
      {
        "resource-name"     = "gaudi-tky-prd-node-pool",
        "resource-group"    = local.group,
        "resource-subgroup" = local.cluster_name,
      },
    )
  }

  node_pools_tags = {
    all                     = []
    gaudi-tky-prd-node-pool = []
  }
}
