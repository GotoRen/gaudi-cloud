output "service_account" {
  description = "EKS ServiceAccount for created IAM Role."
  value       = local.service_account
}

output "iam_role_name" {
  value = aws_iam_role.role.name
}
