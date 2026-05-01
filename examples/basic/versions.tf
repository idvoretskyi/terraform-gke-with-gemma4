terraform {
  required_version = ">= 1.13.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.30"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}
