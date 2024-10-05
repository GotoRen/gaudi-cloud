
data "terraform_remote_state" "cloud-dns" {
  backend = "gcs"

  config = {
    bucket = "gaudi-prd-terraform-tfstate"
    prefix = "platform/gcp/cloud-dns/gaudi-prd"
  }
}
