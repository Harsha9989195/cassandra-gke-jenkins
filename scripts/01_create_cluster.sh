#!/usr/bin/env bash
set -euo pipefail
PROJECT_ID="$(gcloud config get-value project)"
ZONE="${ZONE:-us-central1-a}"

echo "Using project: $PROJECT_ID zone: $ZONE"
gcloud services enable container.googleapis.com

gcloud container clusters create cassandra-gke
--zone "$ZONE"
--num-nodes 3
--machine-type e2-standard-2
--disk-type pd-ssd --disk-size 50
--labels=workload=cassandra

gcloud container clusters get-credentials cassandra-gke --zone "$ZONE"
kubectl get nodes
