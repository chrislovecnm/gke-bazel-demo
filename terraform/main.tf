/*
Copyright 2018 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

///////////////////////////////////////////////////////////////////////////////////////
// This configuration will create a GKE cluster that will be used for hosting
// our Bazel built & deployed Java server and Javascript client pod.
///////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////
// Create the primary cluster for this project.
///////////////////////////////////////////////////////////////////////////////////////
data "google_container_engine_versions" "gke_versions" {
  zone = "${var.zone}"
}

// Create the GKE Cluster
resource "google_container_cluster" "primary" {
  name               = "gke-bazel-tutorial"
  zone               = "${var.zone}"
  initial_node_count = 2
  min_master_version = "${data.google_container_engine_versions.gke_versions.latest_master_version}"

  // Scopes necessary for the nodes to function correctly
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    machine_type = "${var.node_machine_type}"
    image_type   = "COS"

    // (Optional) The Kubernetes labels (key/value pairs) to be applied to each node.
    labels {
      status = "poc"
    }
  }

  master_auth {
    # Best practice
    # Disable basic auth
    # Default behavior for new clusters in GKE 1.12
    username = ""
    password = ""

    client_certificate_config {
      # Best practice
      # Disable client cert
      # Default behavior for new clusters in GKE 1.12
      issue_client_certificate = false
    }
  }

  # TODO is this setting up ip aliasing properly?
  ip_allocation_policy {
    # Best practice
    # Enable VPC-native IPs for pods and services
    # Default behavior for new clusters in GKE 1.12
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${google_container_cluster.primary.zone} --project ${var.project}"
  }
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  disable_on_destroy = false
}
