# Argo CD deployment

After the GKE cluster is deployed, you can deploy Argo CD on it and use Applications resources to provision other
components. Some componenets that are dependencies for Argo CD to work properly, such as Certificate Manager, will
need to be deployed manually first.

```
kubectl apply -k cluster/cluster-config -n kube-system
kubectl apply -k cluster/cert-manager

kubectl apply -f cluster/argocd/argo-cd-auth-secret.yaml -n argocd

kubectl apply -k cluster/argocd -n argocd

// If the apply for argocd fails, run it again. It might fail the first time due to missing CRDs

// Before applying the Applications, you might need to update the repoURL and targetRevision
// if you are working on custom branch
kubectl apply -k cluster/project -n argocd
```
