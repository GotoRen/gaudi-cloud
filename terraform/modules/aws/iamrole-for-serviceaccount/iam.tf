data "aws_iam_policy_document" "policy" {
  dynamic "statement" {
    for_each = var.iam_openid_connect_providers

    content {
      actions = ["sts:AssumeRoleWithWebIdentity"]
      effect  = "Allow"

      condition {
        test     = "StringEquals"
        variable = "${statement.value.url}:sub"
        values   = ["system:serviceaccount:${var.namespace}:${var.sa_name}"]
      }

      condition {
        test     = "StringEquals"
        variable = "${statement.value.url}:aud"
        values   = ["sts.amazonaws.com"]
      }

      principals {
        identifiers = [statement.value.arn]
        type        = "Federated"
      }
    }
  }
}

resource "aws_iam_role" "role" {
  name               = var.sa_name
  assume_role_policy = data.aws_iam_policy_document.policy.json

  tags = var.tags
}
