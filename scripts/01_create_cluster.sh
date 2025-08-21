#!/usr/bin/env bash
set -euo pipefail
PROJECT_ID="${PROJECT_ID:-$(gcloud config get-value project)}"
REGION="${REGION:-us-central1}"
ZONE="${ZONE:-us-central1-a}"

echo "Using project: $PROJECT_ID  region: $REGION  zone: $ZONE"
gcloud services enable container.googleapis.com

gcloud container clusters create cassandra-gke \
  --project "$PROJECT_ID" \
  --zone "$ZONE" \
  --num-nodes 1 \
  --machine-type e2-standard-2 \
  --disk-type pd-ssd --disk-size 50 \
  --labels=workload=cassandra


gcloud container clusters get-credentials cassandra-gke --zone "$ZONE"
kubectl get nodes
