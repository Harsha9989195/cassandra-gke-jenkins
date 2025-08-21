#!/usr/bin/env bash
set -euo pipefail

helm repo add jenkinsci https://charts.jenkins.io >/dev/null 2>&1 || true
helm repo update

kubectl create ns jenkins --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install jenkins jenkinsci/jenkins -n jenkins \
  --set controller.serviceType=ClusterIP \
  --set controller.admin.username=admin \
  --set controller.admin.password=admin123

kubectl rollout status -n jenkins deployment/jenkins --timeout=10m

echo
echo "Open Jenkins:"
echo "kubectl -n jenkins port-forward svc/jenkins 8080:8080"
echo "Then Web Preview → port 8080 → login admin/admin123"
EOF

chmod +x scripts/04_install_jenkins.sh
./scripts/04_install_jenkins.sh
