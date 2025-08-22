pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: gcloud
    image: us-central1-docker.pkg.dev/white-inscriber-469614-a1/jenkins-images/jenkins-gcloud-kubectl
    command: ['cat']
    tty: true
"""
    }
  }

  environment {
    PROJECT_ID = 'white-inscriber-469614-a1'
    REGION     = 'us-central1'
    ZONE       = 'us-central1-a'
    CLUSTER    = 'cassandra-gke'
    GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-sa-key') 

  }

 stage('Auth with GCP') {
  steps {
    container('gcloud') {
      withCredentials([file(credentialsId: 'gcp-sa-key', variable: 'GCLOUD_KEY')]) {
        sh '''
          echo "[INFO] Authenticating to GCP..."
          gcloud auth activate-service-account --key-file=$GCLOUD_KEY
          gcloud config set project $PROJECT_ID
          gcloud config set compute/zone $ZONE
          gcloud container clusters get-credentials $CLUSTER
        '''
      }
    }
  }
}
    
stage('Create GKE Cluster') {
      steps {
        sh 'bash scripts/01_create_cluster.sh'
      }
    }

    stage('Deploy Cassandra on GKE') {
      steps {
        sh 'bash scripts/02_deploy_cassandra.sh'
      }
    }

    stage('Smoke Test Cassandra') {
      steps {
        sh 'bash scripts/03_smoke_cql.sh'
      }
    }

    stage('Feed Data to Cassandra') {
      steps {
        sh 'bash scripts/04_feed_data.sh'
      }
    }
  }

  post {
    success {
      echo '✅ All stages completed successfully. Cassandra is running and data is inserted.'
    }
    failure {
      echo '❌ Pipeline failed. Check the logs for errors.'
    }
  }
}




