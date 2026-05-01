# ---------------------------------------------------------------------------------------------------------------------
# Resolved gcloud-derived values (handy for verifying what Terraform will use)
# ---------------------------------------------------------------------------------------------------------------------

output "resolved_project_id" {
  value       = local.project_id
  description = "Project ID resolved from -var or `gcloud config`."
}

output "resolved_region" {
  value       = local.region
  description = "Region resolved from -var, gcloud, or fallback."
}

output "resolved_zone" {
  value       = local.zone
  description = "Zone resolved from -var, gcloud, or fallback."
}

output "gcloud_account" {
  value       = local._g_account
  description = "Active gcloud account at plan time (informational)."
}

output "billing_project" {
  value       = local.billing_project
  description = "Billing/quota project applied to the google provider, if any."
}

# ---------------------------------------------------------------------------------------------------------------------
# Cluster info
# ---------------------------------------------------------------------------------------------------------------------

output "cluster_name" {
  value       = module.gke.cluster_name
  description = "GKE cluster name."
}

output "cluster_endpoint" {
  value       = module.gke.cluster_endpoint
  description = "GKE cluster endpoint."
  sensitive   = true
}

output "kubectl_configure_command" {
  value       = "gcloud container clusters get-credentials ${module.gke.cluster_name} --zone ${local.zone} --project ${local.project_id}"
  description = "Command to configure kubectl for this cluster."
}

# ---------------------------------------------------------------------------------------------------------------------
# Gemma 4 deployment info
# ---------------------------------------------------------------------------------------------------------------------

output "gemma4_namespace" {
  value       = module.gemma4.namespace
  description = "Namespace where Gemma 4 is deployed."
}

output "gemma4_model" {
  value       = module.gemma4.model
  description = "Gemma 4 model tag pulled by Ollama."
}

output "gemma4_check_status_command" {
  value       = "kubectl -n ${module.gemma4.namespace} get deployments,pods,services"
  description = "Command to inspect the Gemma 4 deployment."
}

output "gemma4_get_ip_command" {
  value       = "kubectl -n ${module.gemma4.namespace} get service ${module.gemma4.service_name} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
  description = "Command to retrieve the external IP of the Gemma 4 LoadBalancer."
}

output "gemma4_test_curl" {
  value       = "curl http://<EXTERNAL_IP>/api/generate -d '{\"model\":\"${module.gemma4.model}\",\"prompt\":\"Hello\"}'"
  description = "Sample curl command (replace <EXTERNAL_IP> with the LoadBalancer IP)."
}
