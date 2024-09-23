variable "vpc_name" {
  type        = string
  description = "The name of the vpc network being created"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "tags" {
  type        = map(string)
  description = "Additional tags for the VPC."
}

variable "public_subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "The list of public subnets being created"
}

variable "private_subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "The list of private subnets being created"
}

variable "public_nat_subnets" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "The list of public nat subnets being created"
}
