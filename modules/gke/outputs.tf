output "cluster_name" {
  value       = google_container_cluster.this.name
  description = "Name of the GKE cluster."
}

output "cluster_endpoint" {
  value       = google_container_cluster.this.endpoint
  description = "Endpoint of the GKE cluster."
}

output "cluster_ca_certificate" {
  value       = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  description = "Public CA certificate of the cluster."
  sensitive   = true
}

output "cluster_location" {
  value       = google_container_cluster.this.location
  description = "Location of the cluster."
}

output "node_pool_name" {
  value       = google_container_node_pool.this.name
  description = "Name of the node pool."
}
