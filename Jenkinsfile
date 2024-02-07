podTemplate(label: 'docker-build',
  cloud: "kubernetes",
  containers: [
    containerTemplate(
      name: 'argo',
      image: 'argoproj/argo-cd-ci-builder:latest',
      command: 'cat',
      ttyEnabled: true
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
            container('argo'){
                checkout scm
            }
        }
        stage('Build'){
            container('docker'){
                script {
                    appImage = docker.build("ongiv/hello_jenkins:latest")
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
        stage('Test'){
            container('docker'){
                script {
                    def NGINX_IP="localhost"
                    def NGINX_PORT="80"

                    def response = httpRequest(
                        httpMode: 'GET',
                        url: "http://${NGINX_IP}:${NGINX_PORT}"
                    )

                    if (response.contains("nginXdocker")) {
                        echo "Nginx 페이지에 'nginXdocker' 텍스트가 포함되어 있습니다"
                    } else {
                        echo "Nginx 페이지에 'nginXdocker' 텍스트가 없습니다."
                    }
                }
            }
        }
        stage('Deploy'){
            container('argo'){
                checkout([$class: 'GitSCM',
                        branches: [[name: '*/master' ]],
                        extensions: scm.extensions,
                        doGenerateSubmoduleConfigurations: false,
                        userRemoteConfigs: [[
                            url: 'git@github.com:ongiv/argoCD_test.git',
                            credentialsId: 'jenkins-ssh-private',
                        ]]
                ])
                sshagent(credentials: ['jenkins-ssh-private']){
                    sh("""
                        #!/usr/bin/env bash
                        set +x
                        export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=no"
                        git config --global user.email "moongb0627@gamil.com"
                        git checkout master
                        cd env/dev && kustomize edit set image ongiv/hello_jenkins:${BUILD_NUMBER} && kustomize edit set replicas my-nginx=1
                        git commit -a -m "updated the image tag"
                        git push
                    """)
                }
            }
        }
    }
}

