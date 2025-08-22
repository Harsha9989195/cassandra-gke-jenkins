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
    command:
    - cat
    tty: true
"""
    }
  }

  stages {
    stage('Check gcloud') {
      steps {
        container('gcloud') {
          sh 'gcloud --version'
        }
      }
    }
  }
}






