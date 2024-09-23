terraform {
  required_version = "1.9.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.3.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
  }

  backend "gcs" {
    bucket = "gaudi-prd-terraform-tfstate"
    prefix = "platform/gcp/gke-cluster/gaudi-prd/asia-northeast1"
  }
}
