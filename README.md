# platform-infra

This is the gitops repository responsible for configuring k8's klusters

This is tighly coupled with backstage.

## Platform stack

- Kubernetes
- ArgoCD
- Vault
- Prometheus
- Grafana
- Kibana
- Elasticsearch
- Filebeat
- External Secret manager
- Backstage

## Logic

Each namespace in k8s referes to a system in backstage and vice verse.
