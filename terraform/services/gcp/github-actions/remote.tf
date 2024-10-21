data "terraform_remote_state" "workload_identity_federation" {
  backend = "gcs"

  config = {
    bucket = "gaudi-prd-terraform-tfstate"
    prefix = "platform/gcp/workload-identity-federation/gaudi-prd/github"
  }
}
