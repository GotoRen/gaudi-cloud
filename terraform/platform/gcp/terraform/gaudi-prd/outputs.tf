output "service_account_email" {
  value = google_service_account.terraform_sa.email
}

output "service_account_key" {
  value     = google_service_account_key.terraform_sa_key.private_key
  sensitive = true
}
