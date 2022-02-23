// Create Instance template
resource "google_compute_instance_template" "gcp-assessment" {
  name        = "${var.project_name}-template"
  project     = var.project_id
  tags = [
    "gcp-assessment-webserver", "allow-http"
  ]
  region               = var.region
  instance_description = "gcp-assessment instance(s)"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = data.google_compute_image.ubuntu.self_link
    auto_delete  = true
    boot         = true
    disk_type    = "pd-ssd"
    disk_size_gb = 50
  }

  network_interface {
    network            = google_compute_network.main.name
    subnetwork         = "us-east"
    subnetwork_project = var.project_id
     access_config {
      // Ephemeral public IP | this issues public ip
     }    
  }
  service_account {
    // Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]
  }  

  metadata_startup_script = file("${path.module}/startup.sh")

  depends_on = [
    google_compute_subnetwork.subnetwork
  ]
}

// Create regional instance group
resource "google_compute_region_instance_group_manager" "gcp-assessment" {
  name                      = "${var.project_name}-igm"
  project                   = var.project_id
  base_instance_name        = "${var.project_name}-webserver"
  region                    = var.region

  version {
    instance_template = google_compute_instance_template.gcp-assessment.id
  }

  target_size = 1

  named_port {
    name = "http"
    port = 80
  }

  //  auto_healing_policies {
  //    health_check      = google_compute_health_check.autohealing.id
  //    initial_delay_sec = 300
  //  }
}

// Create regional autoscaler for HA
resource "google_compute_region_autoscaler" "gcp-assessment" {
  name   = "gcp-assessment-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.gcp-assessment.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 300

    cpu_utilization { //This needs to be updated to scale based on LB traffic
      target = 0.8
    }
  }
}
