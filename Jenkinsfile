podTemplate(label: 'docker-build',
  cloud: "kubernetes",
  containers: [
    containerTemplate(
      name: 'git',
      image: 'node:14-alpine',
      command: 'cat',
      ttyEnabled: true,
      alwaysPullImage: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker:dind',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ]
) {
    node('docker-build') {
        def dockerHubCred = 'docker-cerd'
        def appImage

        stage('Checkout'){
            container('git'){
                // Git 설치
                sh 'apk add --update git'
                checkout scm
            }
        }

        stage('Build'){
            container('docker'){
                script {
                    appImage = docker.build("ongiv/hello_jenkins")
                }
            }
        }

        stage('Test'){
            container('docker'){
                script {
                    appImage.inside {
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }

        stage('Push'){
            container('docker'){
                script {
                    docker.withRegistry('https://registry.hub.docker.com', dockerHubCred){
                        appImage.push("${env.BUILD_NUMBER}")
                        appImage.push("latest")
                    }
                }
            }
        }
    }
}
