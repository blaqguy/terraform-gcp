// SA for Web Server
resource "google_service_account" "service_account" {
  account_id   = "${var.project_name}-account"
  display_name = "${var.project_name}-account"
  description  = "SA used by the webserver to communicate to other gcp services"
  project      = var.project_id
}

# Attach roles to the SA
resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# Attach roles to the SA
resource "google_project_iam_member" "metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
