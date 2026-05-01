resource "google_container_cluster" "this" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.location

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = var.deletion_protection

  network         = var.network
  subnetwork      = var.subnetwork
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  release_channel {
    channel = var.release_channel
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.private_cluster ? [1] : []
    content {
      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = var.master_ipv4_cidr
      master_global_access_config {
        enabled = true
      }
    }
  }

  lifecycle {
    precondition {
      condition     = !(var.use_spot_vms && var.use_preemptible_vms)
      error_message = "use_spot_vms and use_preemptible_vms are mutually exclusive."
    }
  }
}

resource "google_container_node_pool" "this" {
  project  = var.project_id
  name     = "${var.cluster_name}-np"
  location = var.location
  cluster  = google_container_cluster.this.name

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  initial_node_count = var.initial_node_count

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    spot         = var.use_spot_vms
    preemptible  = var.use_preemptible_vms
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    image_type   = "COS_CONTAINERD"

    dynamic "ephemeral_storage_local_ssd_config" {
      for_each = var.local_ssd_count > 0 ? [1] : []
      content {
        local_ssd_count = var.local_ssd_count
      }
    }

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = merge({ model = "gemma4" }, var.node_labels)

    dynamic "taint" {
      for_each = var.node_taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    dynamic "guest_accelerator" {
      for_each = var.accelerator_type == null ? [] : [1]
      content {
        type  = var.accelerator_type
        count = var.accelerator_count
        gpu_driver_installation_config {
          gpu_driver_version = "LATEST"
        }
      }
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
