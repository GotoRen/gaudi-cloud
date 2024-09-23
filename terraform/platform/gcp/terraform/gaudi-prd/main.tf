resource "google_service_account" "terraform_sa" {
  project      = local.project_id
  account_id   = local.name
  display_name = "Terraform iam admin for Gaudi"
}

resource "google_project_iam_member" "terraform_sa_iam_role" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
  for_each = toset([
    "roles/editor",
    "roles/iam.roleAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/logging.configWriter",
  ])
  role = each.value
}
