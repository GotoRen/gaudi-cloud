provider "google" {
  project               = local.project_id
  region                = local.region
  user_project_override = true
}
