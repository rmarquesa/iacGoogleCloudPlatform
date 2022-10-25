// Dedicated service account for the Bastion instance.
resource "google_service_account" "bastion" {
  display_name  = "GKE Bastion Service Account"
  account_id    = format("%s-sa", var.bastion_name)
}

// Allow access to the Bastion Host via SSH.
resource "google_compute_firewall" "bastion-ssh" {
  name          = format("%s-ssh", var.bastion_name)
  network       = var.network_name
  direction     = "INGRESS"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"] // TODO: Restrict further.

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["bastion"]
}


// The Bastion host.
resource "google_compute_instance" "bastion" {
  name         = var.bastion_name
  machine_type = "e2-micro"
  zone         = var.zone
  project      = var.project_id
  tags         = ["bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  // Install tinyproxy on startup.
  metadata_startup_script = <<SCRIPT
    sudo apt update -y && \
    sudo apt install tinyproxy -y && \
    echo "Allow localhost" | sudo tee -a /etc/tinyproxy/tinyproxy.conf && \
    sudo service tinyproxy restart && \
    exit
  SCRIPT

  network_interface {
    subnetwork = var.subnet_name

    access_config {
      // Not setting "nat_ip", use an ephemeral external IP.
      network_tier = "STANDARD"
    }
  }

  // Allow the instance to be stopped by Terraform when updating configuration.
  allow_stopping_for_update = true

  service_account {
    email  = google_service_account.bastion.email
    scopes = ["cloud-platform"]
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }
}