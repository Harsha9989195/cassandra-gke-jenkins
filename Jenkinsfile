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
    GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-sa-key') // 🔁 Jenkins credential ID
  }

  stages {
    stage('Auth with GCP') {
      steps {
        sh '''
          echo "$GOOGLE_APPLICATION_CREDENTIALS" > /tmp/key.json
          gcloud auth activate-service-account --key-file=/tmp/key.json
          gcloud config set project $PROJECT_ID
          gcloud config set compute/zone $ZONE
          gcloud container clusters get-credentials $CLUSTER --zone $ZONE
        '''
      }
    }

    stage('Deploy Cassandra') {
      steps {
        sh '''
          chmod +x scripts/deploy-cassandra.sh
          ./scripts/deploy-cassandra.sh
        '''
      }
    }

    stage('Feed Data') {
      steps {
        sh '''
          chmod +x scripts/feed-data.sh
          ./scripts/feed-data.sh
        '''
      }
    }
  }
}



