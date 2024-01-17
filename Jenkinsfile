pipeline {
    agent any
    environment {
        dockerHubCred = 'docker-cerd' // Credential ID
        registry = "ongiv"
        imageName = "test"
        dockerImage = "${registry}/${imageName}"
    }

    stages {
        stage('Checkout') {
            steps {
                container('git') {
                    checkout scm
                }
            }
        }

        stage('Build') {
            steps {
                container('docker') {
                    script {
                        // Build Docker image
                        appImage = docker.build(dockerImage)
                    }
                }
            }
        }

        stage('Test') {
            steps {
                container('docker') {
                    script {
                        // Run tests inside Docker container
                        appImage.inside {
                            sh 'npm install'
                            sh 'npm test'
                        }
                    }
                }
            }
        }

        stage('Push') {
            steps {
                container('docker') {
                    script {
                        // Push Docker image to Docker Hub
                        withCredentials([usernamePassword(credentialsId: dockerHubCred, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                            sh "docker push $dockerImage"
                        }
                    }
                }
            }
        }
    }
}

