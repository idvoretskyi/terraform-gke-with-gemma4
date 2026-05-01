output "network_name" {
  value       = google_compute_network.vpc.name
  description = "Name of the VPC network."
}

output "network_id" {
  value       = google_compute_network.vpc.id
  description = "ID of the VPC network."
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "Name of the GKE subnet."
}

output "subnet_id" {
  value       = google_compute_subnetwork.subnet.id
  description = "ID of the GKE subnet."
}

output "pods_range_name" {
  value       = "pods"
  description = "Secondary range name for pods."
}

output "services_range_name" {
  value       = "services"
  description = "Secondary range name for services."
}
