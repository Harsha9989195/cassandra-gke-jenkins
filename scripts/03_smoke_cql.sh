#!/usr/bin/env bash
set -euo pipefail
NS=cassandra
PASS=$(kubectl -n $NS get secret cassandra -o jsonpath='{.data.cassandra-password}' | base64 -d)
POD=$(kubectl -n $NS get pod -l app.kubernetes.io/name=cassandra -o jsonpath='{.items[0].metadata.name}')
kubectl -n $NS exec -i "$POD" -- bash -lc "
cqlsh -u cassandra -p '$PASS' -e "
CREATE KEYSPACE IF NOT EXISTS demo WITH replication={'class':'SimpleStrategy','replication_factor':1};
USE demo;
CREATE TABLE IF NOT EXISTS users(id int PRIMARY KEY, name text);
INSERT INTO users(id,name) VALUES (1,'Harsha');
SELECT * FROM users;"
"
