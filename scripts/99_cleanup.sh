#!/usr/bin/env bash
set -euo pipefail
ZONE="${ZONE:-us-central1-a}"
helm uninstall cassandra -n cassandra || true
helm uninstall jenkins -n jenkins || true
gcloud container clusters delete cassandra-gke --zone "$ZONE" --quiet || true
echo "Cleanup done."
