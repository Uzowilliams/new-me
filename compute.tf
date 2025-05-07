# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "web-server" {
  boot_disk {
    auto_delete = true
    device_name = "web-server"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2504-plucky-amd64-v20250430"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"

  metadata = {
    ssh-keys = "user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4EEll05/tZG8wtbR29ZvxiJiD0/TgaRbEaiU8YQ5Pa/DBWn2bRGrngHlebXi9HwzNQtufBd+c3s8pV4EamsInxwxckl+EcRbADZw8HiI9F5j61pvO8OWbkG4IqF6bVTS4RdxMImkHsECJTMl6LyvP4fLJqeOPPBB1nIVIhjEXKzY7WdDva/vLie0tlK0kq/t0jrI4uDMSrq0ySLupWMU6xgBh63POziZpk2LuO3yjY4kav/sJJKcaRIydmKL/btwiy40H4ZY/PVKsREuQW52IeRRS30lwERWZdUIBk+oSJKmtUaCvXkrZZiVJmGuiHl8OAea6XUimjZ6J2G9b0nzVlVsu2pd78btgxIzLjskIVr1Rq1/ZMwv9d3/97gMRU8KZlG5DR3ePL+AoxFOM/vb4ZtoLBPGlnBgq0qmR9W4WKWvwXNS8tb7xgPJBZ+Y/4J1pmdD4Fm6MxH6/AaucVQ7/iVAeWvCmIq2NHWLCqIJzqQTodmoP4bh08os7/TD76l8= user@DESKTOP-ATMAGF9"
  }

  ### ✅ Added Docker Startup Script Below ###
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io

    echo "${var.docker_password}" | docker login -u "${var.docker_username}" --password-stdin
    docker pull ${var.docker_image_name}
    docker run -d -p 80:80 ${var.docker_image_name}
  EOT

  name = "web-server"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/terra-learn-p01/regions/us-central1/subnetworks/dev-subnet"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "compute-engine-sa@terra-learn-p01.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }

  zone = "us-central1-a"
}
