terraform {
  required_version = "1.9.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.3.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.3.0"
    }
  }

  backend "gcs" {
    bucket = "gaudi-prd-terraform-tfstate"
    prefix = "platform/gcp/workload-identity-federation/gaudi-prd/github"
  }
}
