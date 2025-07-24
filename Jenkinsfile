pipeline {
    agent any

    environment {
        DOCKERHUB_IMAGE = 'yourdockerhubuser/java-demo'
        TAG = "${env.BUILD_NUMBER}"
        K8S_YAML = 'k8s-deployment.yaml'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/youruser/yourrepo.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKERHUB_IMAGE}:${TAG} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${DOCKERHUB_IMAGE}:${TAG}
                            docker logout
                        '''
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    sh '''
                        kubectl config use-context minikube
                        sed 's|<IMAGE_TAG>|${TAG}|g' ${K8S_YAML} | kubectl apply -f -
                    '''
                }
            }
        }
    }
}
