resource "google_container_cluster" "gke_gaudi_prd" {
  project = local.project_id

  ### Control-Plane
  name     = local.cluster_name
  location = local.region # Regional Cluster として構成

  min_master_version = local.cluster_version # Control Plane version
  release_channel {
    channel = "REGULAR" # UNSPECIFIED / RAPID / REGULAR / STABLE
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
    }
  }

  ### Data-Plane
  remove_default_node_pool = true # デフォルトのノードプールを使用しない（削除する）
  initial_node_count       = 1    # クラスタ開始時のノード数（remove_default_node_pool を true にした場合は1以上を設定する必要がある）
  node_pool_auto_config {}
  node_pool_defaults {}

  ### Cluster Network
  network    = data.terraform_remote_state.vpc.outputs.network_self_link
  subnetwork = data.terraform_remote_state.vpc.outputs.subnets_self_links

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#networking_mode
  networking_mode = "VPC_NATIVE" # VPC native traffic routing
  ip_allocation_policy {
    cluster_secondary_range_name  = data.terraform_remote_state.vpc.outputs.subnets_secondary_ranges[0].range_name # Resource => Pods
    services_secondary_range_name = data.terraform_remote_state.vpc.outputs.subnets_secondary_ranges[1].range_name # Resource => service
  }

  ### Addons
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#addons_config
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false # 有効
    }
    http_load_balancing {
      disabled = false # 有効
    }
    network_policy_config {
      disabled = true # 無効
    }
    dns_cache_config {
      enabled = true # 有効
    }
    gce_persistent_disk_csi_driver_config {
      enabled = false # 無効
    }
    gke_backup_agent_config {
      enabled = false # 無効
    }
    config_connector_config {
      enabled = false # 無効
    }
    stateful_ha_config {
      enabled = false # 無効
    }
    ray_operator_config {
      enabled = false # 無効
    }
  }

  ### Security
  enable_shielded_nodes = true # https://cloud.google.com/kubernetes-engine/docs/how-to/shielded-gke-nodes

  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }

  ### Logging/Monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  # monitoring_config {
  #   managed_prometheus {
  #     enabled = true
  #   }
  # }

  ### Maintenance policy
  deletion_protection = false

  maintenance_policy {
    daily_maintenance_window {
      start_time = "19:00" # = JST4:00-8:00
    }
  }

  cost_management_config {
    enabled = true # GKE Cost Allocation
  }

  depends_on = [
    google_project_iam_member.gke_service_account_iam_role
  ]

  resource_labels = merge(
    module.resource_labels.labels,
    {
      "resource-name"     = local.cluster_name,
      "resource-group"    = local.group,
      "resource-subgroup" = local.cluster_name,
    },
  )
}

resource "google_container_node_pool" "gke_gaudi_prd_node_pool" {
  project        = local.project_id
  name           = "${local.cluster_name}-node-pool"
  location       = local.region
  cluster        = google_container_cluster.gke_gaudi_prd.id
  node_locations = local.node_locations

  ### Node Pool
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#autoscaling
  autoscaling {
    min_node_count = local.min_node_count
    max_node_count = local.max_node_count
  }
  node_config {
    machine_type    = local.machine_type
    service_account = google_service_account.gke_service_account.email
    workload_metadata_config {
      mode = "GKE_METADATA" # UNSPECIFIED / GCE_METADATA / GKE_METADATA
    }

    # Access scope: https://developers.google.com/identity/protocols/oauth2/scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",              # Google Cloud Platform API
      "https://www.googleapis.com/auth/logging.write",               # Stackdriver Logging API
      "https://www.googleapis.com/auth/monitoring",                  # Stackdriver Monitoring API
      "https://www.googleapis.com/auth/trace.append",                # Stackdriver Trace API
      "https://www.googleapis.com/auth/service.management.readonly", # Service Management API
      "https://www.googleapis.com/auth/devstorage.read_only",        # Cloud Storage API
    ]
    tags = ["allow-health-checks"]

    labels = merge(
      module.resource_labels.labels,
      {
        "resource-name"     = "${local.cluster_name}-node-pool"
        "resource-group"    = local.group,
        "resource-subgroup" = local.cluster_name,
      },
    )
  }

  ### Maintenance policy
  management {
    auto_upgrade = true # 自動アップグレード機能を有効化
    auto_repair  = true # 自動修復機能を有効化
  }
  upgrade_settings {
    strategy        = "SURGE" # SURGE / BLUE_GREEN
    max_surge       = 1       # アップグレードプロセス中にノードプールの現在のサイズを超えて作成できるノードの最大数
    max_unavailable = 0       # アップグレードプロセス中に同時に使用不可にできるノードの最大数
  }

  depends_on = [
    google_project_iam_member.gke_service_account_iam_role,
    google_container_cluster.gke_gaudi_prd
  ]
}
