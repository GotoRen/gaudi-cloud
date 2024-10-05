//-----------------------------------------------------------------------------
// GSA: gke-service-account
// Description: GKE の動作に必要な最小権限を付与する
//-----------------------------------------------------------------------------
resource "google_service_account" "gke_service_account" {
  project      = local.project_id
  account_id   = "gke-service-account"
  display_name = "gke-service-account"
  description  = "Managed by terraform: GKE の最小権限アカウント"
}

resource "google_project_iam_member" "gke_service_account_iam_role" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.gke_service_account.email}"
  for_each = toset([
    "roles/artifactregistry.reader",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
  ])
  role = each.value
}
