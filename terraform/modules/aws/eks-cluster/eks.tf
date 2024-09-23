resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-master-role.arn
  version  = var.cluster_version

  vpc_config {
    security_group_ids = [aws_security_group.cluster_master.id]
    subnet_ids         = var.subnet_ids
  }

  enabled_cluster_log_types = ["audit", "api", "authenticator", "controllerManager", "scheduler"]

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
    aws_cloudwatch_log_group.group
  ]

  lifecycle {
    ignore_changes = [
      version,
    ]
  }
}

resource "kubernetes_config_map" "aws_auth" {
  data = {
    "mapRoles" = <<CONFIGMAPAWSAUTH
    - rolearn: ${aws_iam_role.eks_node_role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${var.aws_auth_admin_role_arn}
      username: ${var.aws_auth_admin_role_name}
      groups:
        - system:masters
    CONFIGMAPAWSAUTH
  }

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}
