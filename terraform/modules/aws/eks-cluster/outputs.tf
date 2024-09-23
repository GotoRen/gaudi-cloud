/******************************************
	EKS configuration
 *****************************************/
output "cluster" {
  value = aws_eks_cluster.eks_cluster
}

output "cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_master_security_group_id" {
  value = aws_security_group.cluster_master.id
}

output "cluster_nodes_security_group_id" {
  value = aws_security_group.cluster_nodes.id
}

output "aws_auth_admin_role_arn" {
  value = var.aws_auth_admin_role_arn
}

output "aws_auth_admin_role_name" {
  value = var.aws_auth_admin_role_name
}

/******************************************
	IAM configuration
 *****************************************/
output "iam_openid_connect_provider_arn" {
  description = "The ARN assigned by AWS for this provider."
  value       = aws_iam_openid_connect_provider.default.arn
}

output "iam_openid_connect_provider_url" {
  description = "The URL of the identity for this provider."
  value       = aws_iam_openid_connect_provider.default.url
}
