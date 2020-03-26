pipeline {

  environment {
    VERSION = '1.0'
    REGISTRY = 'silviaclaire/hello-app'
    AWS_REGION = 'us-west-2'
    CLUSTER_NAME = 'aws-eks-cluster'

    // DO NOT change this line (used as global variable)
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

    stage('Create EKS Cluster') {
      steps {
        sh 'chmod +x bin/create_or_update_stack.sh'

        sh '''
            # Create Amazon EKS Service Role
            ./bin/create_or_update_stack.sh ${AWS_REGION} eks-role cloudformation/role.yaml

            # Create Amazon EKS Cluster VPC
            ./bin/create_or_update_stack.sh ${AWS_REGION} eks-vpc cloudformation/vpc.yaml
        '''

        sh '''
            # Create Amazon EKS Cluster
            sed -i "s/CLUSTER_NAME/${CLUSTER_NAME}/" cloudformation/cluster.yaml
            ./bin/create_or_update_stack.sh ${AWS_REGION} eks-cluster cloudformation/cluster.yaml

            # Create/Update kubeconfig File for cluster
            aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}

            # NOTE: Wait for your cluster status to show as ACTIVE
            # Test the configuration
            kubectl get svc
        '''
      }
    }
  }
}