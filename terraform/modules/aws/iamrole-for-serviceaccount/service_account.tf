locals {
  service_account = <<SERVICEACCOUNT
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: "${aws_iam_role.role.arn}"
  name: "${var.sa_name}"
  namespace: "${var.namespace}"
SERVICEACCOUNT
}
