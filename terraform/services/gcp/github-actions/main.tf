resource "google_service_account" "github_actions" {
  project      = local.project_id
  account_id   = local.name
  display_name = local.name
  description  = "Managed by terraform: GitHub Actions から GAR へのイメージ Push 用アカウント"
}

resource "google_service_account_iam_member" "github_actions" {
  service_account_id = google_service_account.github_actions.id
  for_each = toset([
    ### GitHub Actions
    "principalSet://iam.googleapis.com/${data.terraform_remote_state.workload_identity_federation.outputs.workload_identity_pool_name}/attribute.org/gaudi-organization",
  ])
  member = each.value
  role   = "roles/iam.workloadIdentityUser"
}

resource "google_project_iam_member" "github_actions" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.github_actions.email}"
  for_each = toset([
    "roles/artifactregistry.createOnPushWriter", # TODO: 過剰権限ではないか
  ])
  role = each.value
}
