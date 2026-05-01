variable "project_id" {
  type        = string
  description = "Google Cloud Project ID."
  nullable    = false
}

variable "region" {
  type        = string
  description = "Region for the subnet."
  nullable    = false
}

variable "name_prefix" {
  type        = string
  description = "Prefix used to name the VPC and subnet."
  nullable    = false
}

variable "subnet_cidr" {
  type        = string
  description = "Primary CIDR for the GKE node subnet."
  default     = "10.0.0.0/24"
}

variable "pod_cidr" {
  type        = string
  description = "Secondary CIDR range for GKE pods."
  default     = "10.1.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = "Secondary CIDR range for GKE services."
  default     = "10.2.0.0/16"
}
