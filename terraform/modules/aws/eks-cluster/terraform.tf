terraform {
  required_version = "1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.44.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.29.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.13.0"
    }
  }
}
