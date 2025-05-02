resource "google_compute_network" "vpc_network" {
  project                 = "terra-learn-p01"
  name                    = "pci-dss-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}