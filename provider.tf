terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.33.0"
    }
  }
}

provider "google" {
  # Configuration options

  project = "terra-learn-p01"
  region  = "us-central1"
  credentials = file("gcp_key.json")
}