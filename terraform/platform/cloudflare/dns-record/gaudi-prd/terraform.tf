terraform {
  required_version = "1.9.5"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.43.0"
    }
  }

  backend "gcs" {
    bucket = "gaudi-prd-terraform-tfstate"
    prefix = "platform/cloudflare/dns-record/gaudi-prd"
  }
}
