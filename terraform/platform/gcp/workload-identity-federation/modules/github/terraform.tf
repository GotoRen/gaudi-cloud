terraform {
  required_version = ">= 1.9.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 7"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.7.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.3.0"
    }
  }

  backend "gcs" {
    bucket = "gaudi-prd-terraform-tfstate"
    prefix = "platform/gcp/workload-identity-federation/modules/github"
  }
}
