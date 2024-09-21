resource "google_service_account" "terraform_sa" {
  account_id   = local.name
  display_name = "Terraform role for gaudi-prd"
}

resource "google_project_iam_member" "terraform_sa_project_role" {
  for_each = toset([
    "roles/owner",
  ])

  project = local.project_id
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
  role    = each.value
}

resource "google_service_account_key" "terraform_sa_key" {
  service_account_id = google_service_account.terraform_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"

  depends_on = [
    google_project_iam_member.terraform_sa_project_role,
  ]
}
