pipeline {
    agent none
    
    stages {
        stage('Build and Push to Docker Hub') {
            agent {
                kubernetes {
                    label 'docker-build'
                    defaultContainer 'docker'
                }
            }

            environment {
                DOCKER_HUB_CRED = credentials('docker-cerd') // Docker Hub Credential ID
                IMAGE_NAME = "ongiv/was_test"
            }

            steps {
                script {
                    // 레포지토리 체크아웃
                    checkout scm

                    // Docker 이미지 빌드
                    def appImage = docker.build(IMAGE_NAME)

                    // Docker Hub에 로그인
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CRED, usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh "docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD"
                    }

                    // Docker 이미지를 Docker Hub에 푸시
                    appImage.push("${env.BUILD_NUMBER}")
                    appImage.push("latest")
                }
            }
        }
    }
}
