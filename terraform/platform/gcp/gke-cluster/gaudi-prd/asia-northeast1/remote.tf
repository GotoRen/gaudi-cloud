data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    bucket = "gaudi-prd-terraform-tfstate"
    prefix = "platform/gcp/vpc/gaudi-prd"
  }
}
