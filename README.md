# Argo CD deployment


## Secrets

See .examples in /cluster/secrets for secrets

```
kubectl apply -k cluster/cluster-config -n kube-system

kubectl apply -k cluster/cert-manager

kubectl apply -k cluster/istio-controlplane


kubectl apply -f cluster/secrets

kubectl apply -k cluster/argocd -n argocd

// If the apply for argocd fails, run it again. It might fail the first time due to missing CRDs

// Before applying the Applications, you might need to update the repoURL and targetRevision
// if you are working on custom branch
kubectl apply -k cluster/project -n argocd

kubectl apply -f cluster/app-of-apps.yaml


```
