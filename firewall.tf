resource "google_compute_firewall" "default" {
  name    = "frontend-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22", "443"]
  }

  source_tags = ["web"]

}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = "pci-dss-vpc" # or your actual VPC name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
