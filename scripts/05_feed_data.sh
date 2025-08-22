#!/usr/bin/env bash
set -euo pipefail
echo "Feeding sample data into Cassandra..."
POD=$(kubectl get pods -n cassandra -l app.kubernetes.io/name=cassandra -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n cassandra -it "$POD" -- \
	cqlsh -e "
USE demo;
    INSERT INTO users (id, name) VALUES (10, 'Harsha');
    INSERT INTO users (id, name) VALUES (11, 'Kiran');
    INSERT INTO users (id, name) VALUES (12, 'Sai');
    SELECT * FROM users;
"
echo "✅ Data feed complete."
