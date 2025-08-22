#  Cassandra on GKE + Jenkins CI/CD Pipeline

This project automates the deployment of a **Cassandra NoSQL database cluster** on **Google Kubernetes Engine (GKE)**, and feeds data into it using a **Jenkins-driven CI/CD pipeline**.

---

##  Key Features

-  **Automated GKE cluster creation**
-  **Deploy Cassandra via Helm chart**
-  **Data ingestion** using CQL (Cassandra Query Language) for write/read verification
-  **Jenkins integration** to orchestrate deployment and automation
-  Clean-up script to safely tear down resources and avoid costs

---

##  Prerequisites

- A **Google Cloud Project** with billing enabled  
- **Cloud Shell** or local environment with:
  - `gcloud`
  - `kubectl`
  - `helm`
  - `bash` shell scripting

---

##  Project Structure

assandra-gke-jenkins/
├── scripts/

│ ├── 01_create_cluster.sh # Create a GKE cluster

│ ├── 02_deploy_cassandra.sh # Deploy Cassandra via Helm

│ ├── 03_smoke_cql.sh # Smoke test: write & read via CQL

│ ├── 04_install_jenkins.sh # (Optional) Install Jenkins in-cluster

│ ├── 99_cleanup.sh # Tear down resources

├── Jenkinsfile # CI pipeline for orchestration

└── README.md



---

##  Quick Start



```bash
git clone https://github.com/Harsha9989195/cassandra-gke-jenkins.git
cd cassandra-gke-jenkins


2. Provision GKE Cluster
bash ./scripts/01_create_cluster.sh

3. Deploy Cassandra Cluster
bash ./scripts/02_deploy_cassandra.sh

4. Smoke Test Cassandra (Write & Read)
bash ./scripts/03_smoke_cql.sh

5. (Optional) Install Jenkins in the Cluster
bash ./scripts/04_install_jenkins.sh


Access Jenkins via Kubernetes port-forwarding:

kubectl -n jenkins port-forward svc/jenkins 8080:8080


Then open Web Preview → port 8080 → login with:

Username: admin

Password: admin123

Copy the contents of the Jenkinsfile into a Pipeline job and trigger the build.

6. Clean-Up Resources
bash ./scripts/99_cleanup.sh
----



