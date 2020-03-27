pipeline {

  environment {
    VERSION = '1.0'
    DOCKER_ID = 'silviaclaire'
    AWS_REGION = 'us-west-2'
    CLUSTER_NAME = 'aws-eks-cluster'
    REGISTRY_CREDENTIAL_ID = 'dockerhub'

    // DO NOT change this line (used as global variable)
    dockerImage = ''
  }

  agent any

  stages {

    stage('Lint') {
      steps{
        // lint all .py files; disable import error
        sh 'find . -type f -name "*.py" | xargs ~/.local/bin/pylint --disable=R,C,W1203,E0401'
        sh 'hadolint Dockerfile'
      }
    }

    stage('Build') {
      steps {
        script {
          dockerImage = docker.build('${DOCKER_ID}/hello-app:${VERSION}')
        }
      }
    }

    stage('Test') {
      steps {
        script {
          dockerImage.inside {
              sh 'python -m pytest -vv -p no:cacheprovider /tests/*.py'
          }
        }
      }
    }

    stage('Publish') {
      when {
        anyOf {
          branch 'staging'
          branch 'master'
        }
      }
      steps {
        script {
          docker.withRegistry('', REGISTRY_CREDENTIAL_ID) {
            dockerImage.push()
            dockerImage.push('latest')
          }
        }
      }
    }

    stage('Clean') {
      steps {
        sh '''
          docker image ls -a
          docker image prune -a -f
          docker image ls -a
        '''
      }
    }

    stage('Create EKS Cluster') {
      when {
        anyOf {
          branch 'staging'
          branch 'master'
        }
      }
      steps {
        sh '''
          chmod +x bin/create_cluster_eks.sh
          ./bin/create_cluster_eks.sh ${AWS_REGION} ${CLUSTER_NAME}
        '''
      }
    }

    stage('Deploy K8s App') {
      when {
        anyOf {
          branch 'staging'
          branch 'master'
        }
      }
      steps {
        sh '''
          chmod +x bin/deploy_k8s_app.sh
          ./bin/deploy_k8s_app.sh ${VERSION}
        '''
      }
    }
  }
}