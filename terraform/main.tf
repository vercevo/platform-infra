variable "master" {
  default = {
    ip   = "192.168.10.218"
    user = "k3s"
    key  = "~/.ssh/id_ed25519"
  }
}

variable "agent" {
  default = {
    ip   = "192.168.10.160"
    user = "k3s"
    key  = "~/.ssh/id_ed25519"
  }
}

resource "null_resource" "k3s_master" {
  connection {
    type        = "ssh"
    host        = var.master.ip
    user        = var.master.user
    private_key = file(var.master.key)
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL -o install_k3s.sh https://get.k3s.io",
      "chmod +x install_k3s.sh",
      "INSTALL_K3S_EXEC='--disable=traefik --write-kubeconfig-mode 644' ./install_k3s.sh"
    ]
  }
}

resource "null_resource" "copy_kubeconfig" {
  depends_on = [null_resource.k3s_master]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = var.master.ip
      user        = var.master.user
      private_key = file(var.master.key)
    }
    inline = [
      "sudo cp /etc/rancher/k3s/k3s.yaml /tmp/k3s.yaml",
      "sudo chown ${var.master.user}:${var.master.user} /tmp/k3s.yaml"
    ]
  }

  provisioner "local-exec" {
    command = <<EOT
      scp -i ${var.master.key} ${var.master.user}@${var.master.ip}:/tmp/k3s.yaml ./k3s.yaml &&
      sed -i 's/127.0.0.1/${var.master.ip}/g' ./k3s.yaml &&
      mkdir -p ~/.kube &&
      mv ./k3s.yaml ~/.kube/config
    EOT
  }
}

resource "null_resource" "k3s_agent" {
  depends_on = [null_resource.k3s_master]

  connection {
    type        = "ssh"
    host        = var.agent.ip
    user        = var.agent.user
    private_key = file(var.agent.key)
  }

  provisioner "remote-exec" {
    inline = [
      # Fetch k3s token from master node
      "TOKEN=$(ssh -o StrictHostKeyChecking=no -i ${var.master.key} ${var.master.user}@${var.master.ip} sudo cat /var/lib/rancher/k3s/server/node-token)",
      # Install k3s agent pointing to master IP with the token
      "curl -sfL -o install_k3s.sh https://get.k3s.io",
      "chmod +x install_k3s.sh",
      "K3S_URL=https://${var.master.ip}:6443 K3S_TOKEN=$TOKEN ./install_k3s.sh"
    ]
  }
  
}
