variable "sa_name" {
  type        = string
  description = "The name of the role."
}

variable "namespace" {
  type        = string
  description = "The name of namespace."
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "iam_openid_connect_providers" {
  type = list(object({
    arn = string
    url = string
  }))
}
