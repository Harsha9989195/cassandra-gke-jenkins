pipeline {
  agent any
  docker {
      image 'us-central1-docker.pkg.dev/white-inscriber-469614-a1/jenkins-images/jenkins-gcloud-kubectl'
    }
  }

  environment {
    PROJECT_ID = 'white-inscriber-469614-a1'          
    REGION     = 'us-central1'
    ZONE       = 'us-central1-a'
    CLUSTER    = 'cassandra-gke'
  }

  stages {
    stage('Clone Repo') {
      steps {
        git branch: 'main', url: 'https://github.com/Harsha9989195/cassandra-gke-jenkins.git'

      }
    }

    stage('Auth with GCP') {
      steps {
        withCredentials([file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
          sh '''
            gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
            gcloud config set project $PROJECT_ID
            gcloud config set compute/zone $ZONE
          '''
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
        sh 'bash scripts/05_feed_data.sh'
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


