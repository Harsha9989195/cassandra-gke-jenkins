Cassandra on GKE + Jenkins (demo)
Prereqs
GCP project with billing ON
Cloud Shell (gcloud, kubectl, helm available)
Quick Start
# 1) create a small GKE cluster
./scripts/01_create_cluster.sh

# 2) deploy Cassandra via Helm and wait until Ready
./scripts/02_deploy_cassandra.sh

# 3) smoke test: write & read a row with CQL
./scripts/03_smoke_cql.sh

# 4) optional: install Jenkins in-cluster (no external LB)
./scripts/04_install_jenkins.sh
# then: kubectl -n jenkins port-forward svc/jenkins 8080:8080
# open Web Preview → port 8080 → login: admin / admin123

# Jenkins pipeline: paste Jenkinsfile content into a Pipeline job and Build
Clean up (avoid cost)
bash
Copy
Edit
./scripts/99_cleanup.sh
