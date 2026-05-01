provider "google" {
  project               = local.project_id
  region                = local.region
  zone                  = local.zone
  billing_project       = local.billing_project
  user_project_override = local.billing_project != null
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
}
