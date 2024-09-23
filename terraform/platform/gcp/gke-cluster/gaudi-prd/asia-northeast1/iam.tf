//-----------------------------------------------------------------------------
// GSA: gke-service-account
// Description: GKE の動作に必要な最小権限を付与する
//-----------------------------------------------------------------------------
resource "google_service_account" "gke" {
  account_id   = "gke-service-account"
  display_name = "gke-service-account"
  description  = "Managed by terraform: GKE の最小権限アカウント"
}

resource "google_project_iam_member" "gke" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.gke.email}"
  for_each = toset([
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader",
    "roles/container.clusterAdmin",
    "roles/compute.networkAdmin",
    "roles/compute.instanceAdmin.v1",
    "roles/iam.serviceAccountUser",
    "roles/container.developer",
    "roles/compute.loadBalancerAdmin",
    "roles/compute.securityAdmin",
    "roles/dns.admin",
  ])
  role = each.value
}
