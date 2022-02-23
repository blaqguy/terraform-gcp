provider "google" {
  credentials = file("tf-service-account.json")
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  credentials = file("tf-service-account.json")
  region      = var.region
  project     = var.project_id
}
