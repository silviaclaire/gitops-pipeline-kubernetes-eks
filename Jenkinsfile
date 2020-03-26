pipeline {

  environment {
    VERSION = '1.0'
    REGISTRY = 'silviaclaire/hello-app'
    dockerImage = ''
  }

  agent any

  stages {

    stage('Git Clone') {
      steps {
        git branch: 'test', url:'https://github.com/silviaclaire/jenkins-pipeline-docker-kubernetes-awseks.git'
      }
    }

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
          dockerImage = docker.build('${REGISTRY}:${VERSION}')
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
      steps {
        script {
          docker.withRegistry('', 'dockerhub') {
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

  }
}