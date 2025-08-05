# Argo CD deployment
 
```
kubectl apply -k cluster/cluster-config -n kube-system
kubectl apply -k cluster/cert-manager

kubectl apply -f cluster/secrets

kubectl apply -k cluster/argocd -n argocd

// If the apply for argocd fails, run it again. It might fail the first time due to missing CRDs

// Before applying the Applications, you might need to update the repoURL and targetRevision
// if you are working on custom branch
kubectl apply -k cluster/project -n argocd


kubectl port-forward svc/argocd-server 8080:443 -n argocd
```
