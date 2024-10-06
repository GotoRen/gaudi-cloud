resource "google_service_account" "cert_manager" {
  project      = local.project_id
  account_id   = local.service_account_name
  display_name = local.service_account_name
  description  = "Managed by terraform: for ${local.service_account_name}"
}

resource "google_service_account_iam_member" "cert_manager_workload_identity" {
  service_account_id = google_service_account.cert_manager.name
  member             = "serviceAccount:${local.project_id}.svc.id.goog[${local.namespace_name}/${local.ksa_name}]"
  role               = "roles/iam.workloadIdentityUser"
}

resource "google_project_iam_member" "cert_manager_iam_role" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.cert_manager.email}"
  for_each = toset([
    "roles/dns.admin", // Cloud DNS 管理者権限: https://cert-manager.io/docs/configuration/acme/dns01/google/
  ])
  role = each.value
}
