pipeline {
    agent any

    environment {
        DOCKERHUB_IMAGE = 'drdocker108/java-demo'
        TAG = "${env.BUILD_NUMBER}"
        K8S_YAML = 'k8s-deployment.yaml'
        KUBECONFIG = 'C:/jenkins-kube/config' // 👈 path to your local kubeconfig
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/vinay2727/dev.git', branch: 'main'
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
                        export KUBECONFIG=C:/jenkins-kube/config

                        echo "Checking available contexts:"
                        kubectl config get-contexts

                        echo "Using context:"
                        kubectl config use-context minikube

                        sed "s|<IMAGE_TAG>|${TAG}|g" ${K8S_YAML} | kubectl apply -f -
                    '''
                }
            }
        }
    }
}
