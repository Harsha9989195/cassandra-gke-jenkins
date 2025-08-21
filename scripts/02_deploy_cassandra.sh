#!/usr/bin/env bash
set -euo pipefail
helm repo add bitnami https://charts.bitnami.com/bitnami
 >/dev/null 2>&1 || true
helm repo update
kubectl create ns cassandra --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install cassandra bitnami/cassandra -n cassandra
kubectl rollout status -n cassandra statefulset/cassandra --timeout=10m
kubectl get pods -n cassandra -o wide
