terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# 1. إنشاء Namespace خاص بالمشروع
resource "kubernetes_namespace" "app_ns" {
  metadata {
    name = "ultralearning-zone"
  }
}

# 2. إنشاء Deployment لتطبيقك بداخل الـ Namespace
resource "kubernetes_deployment" "web_app" {
  metadata {
    name      = "devops-app"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "devops-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "devops-app"
        }
      }

      spec {
        container {
          image = "ghcr.io/othman1990-sys/devops-ultralearning-pipeline:latest"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}
