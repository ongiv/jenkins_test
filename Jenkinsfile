pipeline {
    agent none

    stages {
        stage('Build and Push to Docker Hub') {
            agent {
                kubernetes {
                    yaml """
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      labels:
                        some-label: some-label-value
                    spec:
                      containers:
                      - name: docker
                        image: docker
                        command:
                          - cat
                        tty: true
                    """
                }
            }

            environment {
                DOCKER_HUB_CRED = credentials('docker-cerd') // Docker Hub Credential ID
                IMAGE_NAME = "ongiv/was_test"
            }

            steps {
                script {
                    // Your build and push steps
                }
            }
        }
    }
}

