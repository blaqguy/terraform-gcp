// Create Cloud Router
resource "google_compute_router" "router" {
  name    = "${var.project_name}-router"
  network = google_compute_network.main.id
  region  = var.region
}

#######################################################
# Cloud Router and Nat have to be created in each region
# That we'll have private instances/services in
## Dirty way of provisioning these, will fix later ##
#######################################################
// Create Cloud NAT
resource "google_compute_router_nat" "nat" {
  name                               = "${var.project_name}-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  region                             = google_compute_router.router.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
