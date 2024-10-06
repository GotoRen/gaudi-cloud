resource "google_service_account" "external_dns" {
  project      = local.project_id
  account_id   = local.service_account_name
  display_name = local.service_account_name
  description  = "Managed by terraform: for ${local.service_account_name}"
}

resource "google_service_account_iam_member" "external_dns_workload_identity" {
  service_account_id = google_service_account.external_dns.name
  member             = "serviceAccount:${local.project_id}.svc.id.goog[${local.namespace_name}/${local.ksa_name}]"
  role               = "roles/iam.workloadIdentityUser"
}

resource "google_project_iam_member" "external_dns_iam_role" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.external_dns.email}"
  for_each = toset([
    "roles/dns.admin", // Cloud DNS 管理者権限: https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/gke.md#workload-identity
  ])
  role = each.value
}
