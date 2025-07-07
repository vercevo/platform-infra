#!/bin/bash

MASTER_TARGETS=(
  "k3s@192.168.10.218"  
)

AGENT_TARGETS=(
  "k3s@192.168.10.160"
)

SSH_KEY="$HOME/.ssh/id_ed25519"  

uninstall_k3s() {
  local TARGET=$1
  echo "============================"
  echo "Checking k3s on $TARGET..."
  ssh -i "$SSH_KEY" "$TARGET" bash -c "'
    if command -v k3s >/dev/null 2>&1 || [ -f /usr/local/bin/k3s-uninstall.sh ] || [ -f /usr/local/bin/k3s-agent-uninstall.sh ]; then
      echo \"k3s detected, uninstalling...\"
      sudo /usr/local/bin/k3s-uninstall.sh 2>/dev/null || sudo /usr/local/bin/k3s-agent-uninstall.sh 2>/dev/null || curl -sfL https://get.k3s.io | sudo sh -s - --uninstall
      echo \"Removing leftover files...\"
      sudo rm -rf /var/lib/rancher/k3s /etc/rancher/k3s
      echo \"Uninstall complete on $TARGET.\"
    else
      echo \"k3s not found on $TARGET.\"
    fi
  '"
}

echo "Starting uninstall on master nodes..."
for TARGET in "${MASTER_TARGETS[@]}"; do
  uninstall_k3s "$TARGET"
done

echo "Starting uninstall on agent nodes..."
for TARGET in "${AGENT_TARGETS[@]}"; do
  uninstall_k3s "$TARGET"
done

echo "Reseting Terraform state..."
cd "$(dirname "$0")" || exit 1
terraform init -reconfigure
terraform destroy -auto-approve || true

echo "All done."
