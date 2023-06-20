#!/bin/bash
set -ex

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# kubectl port-forward -n argocd svc/argocd-server 8080:443
# ARGOCD_PASSWORD=$(kubectl get  -n argocd secret argocd-initial-admin-secret -o json | jq -r .data.password | base64 -d)
# echo $ARGOCD_PASSWORD
# kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
