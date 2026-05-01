module "network" {
  source = "../../modules/network"

  project_id   = local.project_id
  region       = local.region
  name_prefix  = var.cluster_name
  subnet_cidr  = var.subnet_cidr
  pod_cidr     = var.pod_cidr
  service_cidr = var.service_cidr
}

module "gke" {
  source = "../../modules/gke"

  project_id          = local.project_id
  location            = local.zone
  cluster_name        = var.cluster_name
  network             = module.network.network_name
  subnetwork          = module.network.subnet_name
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name
  release_channel     = var.release_channel
  deletion_protection = var.deletion_protection
  private_cluster     = var.private_cluster

  min_node_count      = var.min_node_count
  max_node_count      = var.max_node_count
  initial_node_count  = var.initial_node_count
  machine_type        = var.machine_type
  disk_size_gb        = var.disk_size_gb
  disk_type           = var.disk_type
  local_ssd_count     = var.local_ssd_count
  use_spot_vms        = var.use_spot_vms
  use_preemptible_vms = var.use_preemptible_vms
  accelerator_type    = var.accelerator_type
  accelerator_count   = var.accelerator_count
}

module "gemma4" {
  source = "../../modules/gemma4"

  namespace    = var.gemma4_namespace
  replicas     = var.gemma4_replicas
  image        = var.gemma4_image
  model        = var.gemma4_model
  resources    = var.gemma4_resources
  service_type = var.gemma4_service_type

  depends_on = [module.gke]
}
