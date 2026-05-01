variable "name" {
  type        = string
  description = "Workload name (used for the deployment, service, and labels)."
  default     = "gemma4"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace to deploy into."
  default     = "gemma4"
}

variable "replicas" {
  type        = number
  description = "Number of pod replicas."
  default     = 1
}

variable "image" {
  type        = string
  description = "Container image for the Ollama runtime serving Gemma 4."
  default     = "ollama/ollama:latest"
}

variable "model" {
  type        = string
  description = "Gemma 4 model tag pulled by Ollama at startup. See https://ollama.com/library/gemma4."
  default     = "gemma4:e2b"
}

variable "container_port" {
  type        = number
  description = "Port the Ollama API listens on inside the container."
  default     = 11434
}

variable "service_type" {
  type        = string
  description = "Kubernetes Service type."
  default     = "LoadBalancer"
  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.service_type)
    error_message = "service_type must be one of ClusterIP, NodePort, or LoadBalancer."
  }
}

variable "service_port" {
  type        = number
  description = "External port for the Service."
  default     = 80
}

variable "resources" {
  type = object({
    cpu_request    = optional(string, "1")
    cpu_limit      = optional(string, "2")
    memory_request = optional(string, "5Gi")
    memory_limit   = optional(string, "6Gi")
  })
  description = "Pod resource requests and limits, sized for gemma4:e2b on t2a-standard-2."
  default     = {}
}

variable "node_selector" {
  type        = map(string)
  description = "Node selector to pin pods to the Gemma 4 node pool."
  default     = { model = "gemma4" }
}

variable "tolerations" {
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
  }))
  description = "Tolerations applied to pods so they can be scheduled on tainted nodes."
  default = [
    {
      key      = "dedicated"
      operator = "Equal"
      value    = "gemma4"
      effect   = "NoSchedule"
    },
    {
      key      = "kubernetes.io/arch"
      operator = "Equal"
      value    = "arm64"
      effect   = "NoSchedule"
    }
  ]
}

variable "extra_env" {
  type        = map(string)
  description = "Additional environment variables to inject into the container."
  default     = {}
}
