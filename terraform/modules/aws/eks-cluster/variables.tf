/******************************************
	VPC
 *****************************************/
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}

variable "subnet_ids" {
  type        = list(any)
  description = "The IDs of the Subnet."
}

/******************************************
	EKS
 *****************************************/
variable "cluster_name" {
  type        = string
  description = "Name of the cluster."
}

variable "cluster_version" {
  type        = string
  description = "Desired Kubernetes master version."
}

variable "node_groups" {
  type        = list(any)
  description = "Manages an EKS Node Groups."
}

variable "aws_auth_admin_role_arn" {
  type        = string
  description = "ARN of the aws-auth admin role."
}

variable "aws_auth_admin_role_name" {
  type        = string
  description = "Name of the aws-auth admin role."
}

/******************************************
	resource-labels
 *****************************************/
variable "tags" {
  type        = map(string)
  description = "Additional tags for the EKS."
}
