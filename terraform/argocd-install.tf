terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}

provider "null" {}

resource "null_resource" "install_argocd_and_app_of_apps" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -k https://github.com/argoproj/argo-cd/manifests/crds?ref=stable &&
      kubectl apply -f ${path.module}/app-of-apps.yaml
    EOT
  }
}