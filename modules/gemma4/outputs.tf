output "namespace" {
  value       = kubernetes_namespace_v1.this.metadata[0].name
  description = "Namespace where Gemma 4 is deployed."
}

output "deployment_name" {
  value       = kubernetes_deployment_v1.this.metadata[0].name
  description = "Name of the Gemma 4 Deployment."
}

output "service_name" {
  value       = kubernetes_service_v1.this.metadata[0].name
  description = "Name of the Gemma 4 Service."
}

output "service_type" {
  value       = kubernetes_service_v1.this.spec[0].type
  description = "Service type."
}

output "model" {
  value       = var.model
  description = "Gemma 4 model tag pulled by Ollama."
}
