pipeline {
  agent {
    dockerContainer {
      image 'us-central1-docker.pkg.dev/white-inscriber-469614-a1/jenkins-images/jenkins-gcloud-kubectl'
    }
  }

  environment {
    PROJECT_ID = 'white-inscriber-469614-a1'
    REGION     = 'us-central1'
    ZONE       = 'us-central1-a'
    CLUSTER    = 'cassandra-gke'
    GCP_KEY    = credentials('gcp-sa-key') // Replace with your Jenkins credential ID
  }


      stages {
        stage('Clone Repo') {
          steps {
            git url: 'https://github.com/Harsha9989195/cassandra-gke-jenkins.git', branch: 'main'
          }
        }

        stage('Auth with GCP') {
          steps {
            sh '''
              echo "$GCP_KEY" > /tmp/key.json
              gcloud auth activate-service-account --key-file=/tmp/key.json
              gcloud config set project $PROJECT_ID
              gcloud auth configure-docker $REGION-docker.pkg.dev
            '''
          }
        }

        stage('Create GKE Cluster') {
          steps {
            sh 'chmod +x scripts/create-cluster.sh && ./scripts/create-cluster.sh'
          }
        }

        stage('Deploy Cassandra') {
          steps {
            sh 'chmod +x scripts/deploy-cassandra.sh && ./scripts/deploy-cassandra.sh'
          }
        }

        stage('Feed Data') {
          steps {
            sh 'chmod +x scripts/feed-data.sh && ./scripts/feed-data.sh'
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ Cassandra deployed and data inserted successfully!"
    }
    failure {
      echo "❌ Something failed. Check logs above."
    }
  }
}



