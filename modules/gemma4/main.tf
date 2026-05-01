resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels = {
      app                            = var.name
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        node_selector = var.node_selector

        dynamic "toleration" {
          for_each = var.tolerations
          content {
            key      = toleration.value.key
            operator = toleration.value.operator
            value    = toleration.value.value
            effect   = toleration.value.effect
          }
        }

        container {
          name              = var.name
          image             = var.image
          image_pull_policy = "IfNotPresent"

          port {
            container_port = var.container_port
            name           = "http"
          }

          env {
            name  = "OLLAMA_KEEP_ALIVE"
            value = "24h"
          }

          env {
            name  = "OLLAMA_MODELS"
            value = "/models"
          }

          env {
            name  = "GEMMA4_MODEL"
            value = var.model
          }

          dynamic "env" {
            for_each = var.extra_env
            content {
              name  = env.key
              value = env.value
            }
          }

          resources {
            requests = {
              cpu    = var.resources.cpu_request
              memory = var.resources.memory_request
            }
            limits = {
              cpu    = var.resources.cpu_limit
              memory = var.resources.memory_limit
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.container_port
            }
            initial_delay_seconds = 15
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 6
          }

          liveness_probe {
            tcp_socket {
              port = var.container_port
            }
            initial_delay_seconds = 60
            period_seconds        = 20
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          lifecycle {
            post_start {
              exec {
                command = ["/bin/sh", "-c", "ollama pull ${var.model} || true"]
              }
            }
          }

          volume_mount {
            name       = "models"
            mount_path = "/models"
          }
        }

        volume {
          name = "models"
          empty_dir {}
        }
      }
    }
  }

  wait_for_rollout = true
}

resource "kubernetes_service_v1" "this" {
  metadata {
    name      = var.name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels = {
      app = var.name
    }
  }

  spec {
    type     = var.service_type
    selector = { app = var.name }

    port {
      name        = "http"
      port        = var.service_port
      target_port = var.container_port
    }
  }
}
