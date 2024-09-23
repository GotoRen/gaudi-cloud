resource "google_service_account" "gaudi_frontend" {
  project      = local.project_id
  account_id   = local.service_account_name
  display_name = local.service_account_name
  description  = "Managed by terraform: for ${local.service_account_name}"
}

resource "google_project_iam_member" "gaudi_frontend_iam_role" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.gaudi_frontend.email}"
  for_each = toset([
    "roles/storage.admin", # https://cloud.google.com/storage/docs/access-control/iam-roles
  ])
  role = each.value
}
