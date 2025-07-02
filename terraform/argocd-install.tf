 
resource "null_resource" "install_argocd_and_app_of_apps" {
  depends_on = [null_resource.copy_kubeconfig]

  provisioner "local-exec" {
    command = <<EOT
      kubectl create namespace argocd &&
      kubectl apply -k https://github.com/argoproj/argo-cd/manifests/crds?ref=stable &&
      kubectl apply -f ${path.module}/app-of-apps.yaml
    EOT
  }
}
