PodTemplate(label: 'docker-build',
  cloud: "kubernetes",
  containers: [
    containerTemplate(
      name: 'git',
      image: 'alpine/git',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker',
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
                checkout scm
            }
        }

        stage('Build'){
            container('docker'){
                script {
                    appImage = docker.build("ongiv/was_test") 
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
