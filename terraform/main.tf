variable "project" {
  default = "gcp-yuito-sandbox"
}

variable "region" {
  default = "asia-northeast1"
}

variable "zone" {
  default = "asia-northeast1-a"
}

variable "network_name" {
  default = "gcp-yuito-sandbox"
}

provider "google" {
  region = "${var.region}"
  project = "${var.project}"
}

resource "google_compute_network" "default" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

data "google_client_config" "current" {}

data "google_container_engine_versions" "default" {
  zone = "${var.zone}"
}

resource "google_container_cluster" "default" {
  name               = "${var.network_name}"
  zone               = "${var.zone}"
  initial_node_count = 3
  # min_master_version = "${data.google_container_engine_versions.default.latest_node_version}"
  min_master_version = "1.11.7-gke.4"
  network            = "${google_compute_subnetwork.default.name}"
  subnetwork         = "${google_compute_subnetwork.default.name}"

  // Use legacy ABAC until these issues are resolved:
  //   https://github.com/mcuadros/terraform-provider-helm/issues/56
  //   https://github.com/terraform-providers/terraform-provider-kubernetes/pull/73
  enable_legacy_abac = true

  master_auth {
    username = ""
    password = ""
  }

  // Wait for the GCE LB controller to cleanup the resources.
  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 90"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
//    preemptible  = true
    machine_type = "f1-micro"
  }
}

output network {
  value = "${google_compute_subnetwork.default.network}"
}

output subnetwork_name {
  value = "${google_compute_subnetwork.default.name}"
}

// Static IP
resource "google_compute_global_address" "ip_address" {
  name = "gcp-yuito-sandbox-static-ip"
}

output cluster_name {
  value = "${google_container_cluster.default.name}"
}

output cluster_region {
  value = "${var.region}"
}

output cluster_zone {
  value = "${google_container_cluster.default.zone}"
}

output static_ip {
  value = "${google_compute_global_address.ip_address.address}"
}
