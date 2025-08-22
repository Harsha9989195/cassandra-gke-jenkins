pipeline {
  agent any

  environment {
    IMAGE = 'us-central1-docker.pkg.dev/white-inscriber-469614-a1/jenkins-images/jenkins-gcloud-kubectl'
  }

  stages {
    stage('Run container') {
      steps {
        script {
          docker.withRegistry('https://us-central1-docker.pkg.dev', 'gcp-artifact-creds') {
            def container = docker.image("${IMAGE}").run('-d')
            sh "docker exec ${container.id} gcloud --version"
            container.stop()
          }
        }
      }
    }
  }





