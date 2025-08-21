#!/usr/bin/env bash
set -euo pipefail
NS=cassandra
PASS=$(kubectl -n $NS get secret cassandra -o jsonpath='{.data.cassandra-password}' | base64 -d)
POD=$(kubectl -n $NS get pod -l app.kubernetes.io/name=cassandra -o jsonpath='{.items[0].metadata.name}')

kubectl -n $NS exec -it $POD -- cqlsh -u cassandra -p "$PASS" -e "SELECT release_version FROM system.local;"

