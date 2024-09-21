output "workload_identity_pool_name" {
  value = google_iam_workload_identity_pool.github_actions.name
}

output "workload_identity_pool_provider_name" {
  value = google_iam_workload_identity_pool_provider.github_actions.name
}
