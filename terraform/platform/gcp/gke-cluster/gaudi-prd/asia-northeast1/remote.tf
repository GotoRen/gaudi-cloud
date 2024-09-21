data "terraform_remote_state" "network" {
  backend = "gcs"

  config = {
    bucket = "gaudi-prd-terraform-tfstate"
    prefix = "platform/gcp/network/gaudi-prd"
  }
}
