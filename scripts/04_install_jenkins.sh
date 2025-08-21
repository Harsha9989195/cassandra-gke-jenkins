#!/usr/bin/env bash
set -euo pipefail
helm repo add jenkinsci https://charts.jenkins.io
 >/dev/null 2>&1 || true
helm repo update
kubectl create ns jenkins --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install jenkins jenkinsci/jenkins -n jenkins
--set controller.serviceType=ClusterIP
--set controller.adminUser=admin
--set controller.adminPassword=admin123
kubectl rollout status -n jenkins deployment/jenkins --timeout=10m
echo
echo "To open Jenkins UI from Cloud Shell:"
echo "kubectl -n jenkins port-forward svc/jenkins 8080:8080"
echo "Then Web Preview → port 8080 → login admin / admin123"
