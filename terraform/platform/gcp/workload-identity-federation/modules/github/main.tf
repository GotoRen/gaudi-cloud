resource "google_iam_workload_identity_pool" "github_actions" {
  provider                  = google-beta
  project                   = local.project_id
  workload_identity_pool_id = local.name
  display_name              = local.name
  description               = "Workload Identity Pool for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  provider                           = google-beta
  project                            = local.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = local.name
  display_name                       = local.name
  description                        = "Workload Identity Provider for GitHub Actions"
  disabled                           = false
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.org"        = "assertion.repository_owner"
  }
  attribute_condition = "attribute.org==\"gaudi-organization\""
}
