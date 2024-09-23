resource "google_service_account" "github_actions" {
  provider     = google-beta
  project      = local.project_id
  account_id   = "github-actions"
  display_name = "github-actions"
  description  = "Managed by terraform: GitHub Actions から GCR / GAR へのイメージ push 用アカウント"
}

resource "google_service_account_iam_member" "github_actions" {
  for_each = toset([
    # GitHub Actions
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.org/gaudi-organization",
  ])
  service_account_id = google_service_account.github_actions.id
  role               = "roles/iam.workloadIdentityUser"
  member             = each.value
}

resource "google_project_iam_member" "github_actions" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.github_actions.email}"
  for_each = toset([
    "roles/artifactregistry.createOnPushWriter", // TODO: 過剰権限ではないか
  ])
  role = each.value
}
