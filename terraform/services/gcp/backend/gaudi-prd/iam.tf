resource "google_service_account" "gaudi_backend" {
  project      = local.project_id
  account_id   = local.service_account_name
  display_name = local.service_account_name
  description  = "Managed by terraform: for ${local.service_account_name}"
}

resource "google_service_account_iam_member" "gaudi_backend_workload_identity" {
  service_account_id = google_service_account.gaudi_backend.name
  member             = "serviceAccount:${local.project_id}.svc.id.goog[${local.namespace_name}/${local.ksa_name}]"
  role               = "roles/iam.workloadIdentityUser"
}

resource "google_project_iam_member" "gaudi_backend_iam_role" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.gaudi_backend.email}"
  for_each = toset([
    "roles/spanner.databaseUser", # https://cloud.google.com/spanner/docs/iam#roles
  ])
  role = each.value
}
