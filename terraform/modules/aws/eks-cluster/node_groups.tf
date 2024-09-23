resource "aws_eks_node_group" "node_groups" {
  count = length(var.node_groups)

  node_group_name = "${aws_eks_cluster.eks_cluster.name}-${var.node_groups[count.index].additional_name}"

  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_role_arn = aws_iam_role.eks-node-role.arn

  subnet_ids = var.node_groups[count.index].subnet_ids

  ami_type       = var.node_groups[count.index].ami_type
  disk_size      = var.node_groups[count.index].disk_size
  instance_types = [var.node_groups[count.index].instance_type]
  capacity_type  = var.node_groups[count.index].capacity_type

  scaling_config {
    desired_size = var.node_groups[count.index].desired_capacity
    max_size     = var.node_groups[count.index].max_size
    min_size     = var.node_groups[count.index].min_size
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly,
    aws_iam_role_policy_attachment.ec2_role_for_ssm,
    aws_iam_role_policy_attachment.ssm_managed_ec2_instance_default_policy,
    aws_iam_role_policy_attachment.ssm_managed_instance_core
  ]

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,
      scaling_config[0].max_size,
      scaling_config[0].min_size
    ]
  }
}

resource "aws_autoscaling_group_tag" "node_groups_tags" {
  count = length(aws_eks_node_group.node_groups) * length(var.tags)

  autoscaling_group_name = aws_eks_node_group.node_groups[floor(count.index / length(var.tags))].resources[0].autoscaling_groups[0].name

  tag {
    key                 = keys(var.tags)[floor(count.index % length(var.tags))]
    value               = values(var.tags)[floor(count.index % length(var.tags))]
    propagate_at_launch = true # インスタンス起動時にタグを伝搬する
  }

  depends_on = [
    aws_eks_node_group.node_groups
  ]
}
