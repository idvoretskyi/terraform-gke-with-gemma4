variable "project_id" {
  type        = string
  description = "Google Cloud Project ID."
  nullable    = false
}

variable "location" {
  type        = string
  description = "Cluster location (zone for zonal cluster, region for regional)."
  nullable    = false
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster."
  default     = "gemma4-cluster"
}

variable "network" {
  type        = string
  description = "Name of the VPC network."
  nullable    = false
}

variable "subnetwork" {
  type        = string
  description = "Name of the subnetwork."
  nullable    = false
}

variable "pods_range_name" {
  type        = string
  description = "Secondary range name for pods."
  default     = "pods"
}

variable "services_range_name" {
  type        = string
  description = "Secondary range name for services."
  default     = "services"
}

variable "release_channel" {
  type        = string
  description = "GKE release channel."
  default     = "RAPID"
  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE"], var.release_channel)
    error_message = "release_channel must be one of RAPID, REGULAR, or STABLE."
  }
}

variable "deletion_protection" {
  type        = bool
  description = "Whether the cluster is protected from deletion."
  default     = false
}

variable "private_cluster" {
  type        = bool
  description = "Whether to create a private cluster."
  default     = false
}

variable "master_ipv4_cidr" {
  type        = string
  description = "Master IPv4 CIDR (only used when private_cluster = true)."
  default     = "172.16.0.0/28"
}

# Node pool configuration
variable "min_node_count" {
  type        = number
  description = "Minimum nodes in the node pool."
  default     = 1
}

variable "max_node_count" {
  type        = number
  description = "Maximum nodes in the node pool."
  default     = 3
}

variable "initial_node_count" {
  type        = number
  description = "Initial number of nodes per location."
  default     = 1
}

variable "machine_type" {
  type        = string
  description = "Machine type for node pool VMs."
  default     = "t2a-standard-2"
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB."
  default     = 100
}

variable "disk_type" {
  type        = string
  description = "Boot disk type."
  default     = "pd-standard"
}

variable "local_ssd_count" {
  type        = number
  description = "Number of ephemeral local SSDs to attach to each node."
  default     = 0
}

variable "use_spot_vms" {
  type        = bool
  description = "Use Spot VMs for cost savings."
  default     = true
}

variable "use_preemptible_vms" {
  type        = bool
  description = "Use preemptible VMs (mutually exclusive with use_spot_vms)."
  default     = false
}

variable "node_labels" {
  type        = map(string)
  description = "Additional Kubernetes labels to apply to nodes."
  default     = {}
}

variable "node_taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  description = "Node taints applied to the node pool."
  default = [
    {
      key    = "dedicated"
      value  = "gemma4"
      effect = "NO_SCHEDULE"
    }
  ]
}

variable "accelerator_type" {
  type        = string
  description = "Optional GPU accelerator type (e.g. nvidia-l4). Set null to disable."
  default     = null
}

variable "accelerator_count" {
  type        = number
  description = "Number of accelerators per node when accelerator_type is set."
  default     = 1
}
