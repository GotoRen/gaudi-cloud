resource "google_service_account" "main" {
  project      = local.project_id
  account_id   = local.service_name
  display_name = local.service_name
  description  = "Managed by terraform: for ${local.service_name}"
}

resource "google_service_account_iam_member" "main" {
  service_account_id = google_service_account.main.name
  member             = "serviceAccount:${local.project_id}.svc.id.goog[${local.namespace}/${local.ksa_name}]"
  role               = "roles/iam.workloadIdentityUser"
}

resource "google_project_iam_member" "main" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.main.email}"
  for_each = toset([
    "roles/spanner.databaseUser", # https://cloud.google.com/spanner/docs/iam#roles
  ])
  role = each.value
}
