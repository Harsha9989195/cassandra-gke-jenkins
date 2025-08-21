Cassandra on GKE with Jenkins Automation

This demo shows how to:

Deploy a Cassandra cluster on Google Kubernetes Engine (GKE)

Automate feeding data into Cassandra using Jenkins pipeline

1. Prerequisites

Google Cloud project with billing enabled

Cloud Shell
 or gcloud CLI

Terraform / Helm installed (Cloud Shell has these)

GitHub repo to store pipeline code

2. Create GKE Cluster
export PROJECT_ID=$(gcloud config get-value project)
export ZONE=us-central1-a

gcloud services enable container.googleapis.com

gcloud container clusters create cassandra-gke \
  --project $PROJECT_ID \
  --zone $ZONE \
  --num-nodes 2 \
  --machine-type e2-standard-2

gcloud container clusters get-credentials cassandra-gke --zone $ZONE

3. Deploy Cassandra with Helm
kubectl create ns cassandra
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install cassandra bitnami/cassandra -n cassandra
kubectl -n cassandra get pods

4. Install Jenkins with Helm
kubectl create ns jenkins
helm repo add jenkinsci https://charts.jenkins.io
helm upgrade --install jenkins jenkinsci/jenkins -n jenkins \
  --set controller.admin.username=admin \
  --set controller.admin.password=Admin#12345 \
  --set controller.persistence.enabled=false
kubectl rollout status -n jenkins deployment/jenkins --timeout=10m
kubectl -n jenkins port-forward svc/jenkins 8080:8080


Open Cloud Shell Web Preview → Port 8080
Login: admin / Admin#12345

5. Jenkins Pipeline

Create a Pipeline job in Jenkins → paste this script:

pipeline {
  agent any
  stages {
    stage('Check Cassandra Version') {
      steps {
        sh '''
          [ -x ./kubectl ] || { curl -sSL https://dl.k8s.io/release/v1.30.3/bin/linux/amd64/kubectl -o kubectl; chmod +x kubectl; }
          NS=cassandra
          POD=$(./kubectl -n $NS get pod -l app.kubernetes.io/name=cassandra -o jsonpath='{.items[0].metadata.name}')
          PASS=$(./kubectl -n $NS get secret cassandra -o jsonpath='{.data.cassandra-password}' | base64 -d)
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "SELECT release_version FROM system.local;"
        '''
      }
    }
    stage('Feed Data') {
      steps {
        sh '''
          NS=cassandra
          POD=$(./kubectl -n $NS get pod -l app.kubernetes.io/name=cassandra -o jsonpath='{.items[0].metadata.name}')
          PASS=$(./kubectl -n $NS get secret cassandra -o jsonpath='{.data.cassandra-password}' | base64 -d)

          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "CREATE KEYSPACE IF NOT EXISTS demo WITH replication={'class':'SimpleStrategy','replication_factor':1};"
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "CREATE TABLE IF NOT EXISTS demo.users(id int PRIMARY KEY, name text);"
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "INSERT INTO demo.users(id,name) VALUES (999,'demo-row');"
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "SELECT * FROM demo.users WHERE id=999;"
        '''
      }
    }
  }
}


✅ When the pipeline runs, you should see output like:

id  | name
-----+----------
 999 | demo-row

6. Cleanup (to avoid charges)
helm uninstall cassandra -n cassandra
helm uninstall jenkins -n jenkins
gcloud container clusters delete cassandra-gke --zone us-central1-a --quiet

🎯 Outcome

Cassandra deployed on GKE

Jenkins pipeline created schema, inserted data, and verified it

End-to-end automation demonstrated successfully
