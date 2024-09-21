//-----------------------------------------------------------------------------
// IMPORTANT NOTE
// - GSA gke-service-account は GKE の動作に必要な最小権限を付与する
//-----------------------------------------------------------------------------
// SA: gke-service-account
resource "google_service_account" "gke-service-account" {
  account_id   = local.name
  display_name = local.name
  description  = "Managed by terraform: GKE の最小権限アカウント"
}

// IAM: gke-service-account に必要な最小権限を追加する
resource "google_project_iam_member" "gke-service-account" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.gke-service-account.email}"
  for_each = toset([
    // see https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster?hl=ja#use_least_privilege_sa
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

# // GCS: gke-service-account に GAR への取得権限を追加する
# resource "google_storage_bucket_iam_member" "gke-service-account-gar-asia" {
#   bucket = "asia.artifacts.${local.project_id}.appspot.com"
#   role   = "roles/storage.objectViewer" // see https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster?hl=ja#use_least_privilege_sa
#   member = "serviceAccount:${google_service_account.gke-service-account.email}"
# }
