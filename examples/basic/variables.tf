# ---------------------------------------------------------------------------------------------------------------------
# Optional inputs. Anything left null falls back to the local gcloud config (see gcloud_defaults.tf).
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  type        = string
  description = "Google Cloud Project ID. Defaults to `gcloud config get-value project`."
  default     = null
}

variable "region" {
  type        = string
  description = "Region. Defaults to `gcloud config get-value compute/region`, then us-central1."
  default     = null
}

variable "zone" {
  type        = string
  description = "Zone. Defaults to `gcloud config get-value compute/zone`, then <region>-a."
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# Cluster
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  type        = string
  description = "GKE cluster name."
  default     = "gemma4-cluster"
}

variable "release_channel" {
  type        = string
  description = "GKE release channel."
  default     = "RAPID"
}

variable "deletion_protection" {
  type        = bool
  description = "Whether to enable cluster deletion protection."
  default     = false
}

variable "private_cluster" {
  type        = bool
  description = "Whether to make the cluster private."
  default     = false
}

# ---------------------------------------------------------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------------------------------------------------------

variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "pod_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "service_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

# ---------------------------------------------------------------------------------------------------------------------
# Node pool
# ---------------------------------------------------------------------------------------------------------------------

variable "machine_type" {
  type        = string
  description = "Machine type for node pool VMs (ARM-based default for cost efficiency)."
  default     = "t2a-standard-2"
}

variable "disk_size_gb" {
  type    = number
  default = 100
}

variable "disk_type" {
  type    = string
  default = "pd-standard"
}

variable "use_spot_vms" {
  type    = bool
  default = true
}

variable "use_preemptible_vms" {
  type    = bool
  default = false
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 3
}

variable "initial_node_count" {
  type    = number
  default = 1
}

variable "local_ssd_count" {
  type    = number
  default = 0
}

variable "accelerator_type" {
  type        = string
  description = "Optional GPU accelerator (e.g. nvidia-l4) to attach to nodes. See README for GPU usage."
  default     = null
}

variable "accelerator_count" {
  type    = number
  default = 1
}

# ---------------------------------------------------------------------------------------------------------------------
# Gemma 4 deployment
# ---------------------------------------------------------------------------------------------------------------------

variable "gemma4_namespace" {
  type    = string
  default = "gemma4"
}

variable "gemma4_replicas" {
  type    = number
  default = 1
}

variable "gemma4_image" {
  type        = string
  description = "Container image used to serve Gemma 4. Defaults to ollama/ollama."
  default     = "ollama/ollama:latest"
}

variable "gemma4_model" {
  type        = string
  description = "Gemma 4 model tag pulled by Ollama. See https://ollama.com/library/gemma4."
  default     = "gemma4:e2b"
}

variable "gemma4_resources" {
  type = object({
    cpu_request    = optional(string, "1")
    cpu_limit      = optional(string, "2")
    memory_request = optional(string, "5Gi")
    memory_limit   = optional(string, "6Gi")
  })
  description = "Pod resource requests/limits, sized for gemma4:e2b on t2a-standard-2."
  default     = {}
}

variable "gemma4_service_type" {
  type    = string
  default = "LoadBalancer"
}
