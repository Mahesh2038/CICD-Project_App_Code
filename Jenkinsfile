def registry = 'http://Private IP:8082/'
def imageName = 'JFrog_Host_IP/<Jfrog repo name>/image'
def version   = '2.1.4'

pipeline {
    agent {
        node {
            label 'maven_server'
        }
    }
environment {
    PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
}
    stages {
        // stage('cloning code from repo') {
        //     steps {
        //         git branch:'main', url:<repository url>
        //     }
        // }
        stage('Build the code') {
            steps {
                sh 'mvn clean deploy -Dmaven.test.skip=true'
            }
        }
        stage('Unit test') {
            steps {
                sh 'mvn surefire-report:report' // This command is to run unit test cases separately.
            }
        }
        // stage('SonarQube code analysis') {
        //     environment {
        //         scannerHome = tool 'mk-sonarqube-scanner'  // Define sonar scanner in Env variable.
        //     }
        //     steps {
        //         withSonarQubeEnv('mk-sonarqube-server') {
        //             sh "${scannerHome}/bin/sonar-scanner" //This will communicate with SonarQube server and send analysis report.
        //         }
        //     }
        // }
        
        // stage('Quality Gate') {
        //     steps {
        //         script {
        //             timeout(time: 5, unit: 'MINUTES') {
        //                 def qg = waitForQualityGate()
        //                 if (qg.status != 'OK') {
        //                     error "Pipeline aborted due to quality gate failure: ${qg.status}"
        //                 }
        //             }
        //         }
        //     }
        // }
        
        stage("Jar Publish") {
            steps {
                script {
                        echo '<--------------- Jar Publish Started --------------->'
                        def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jenkins-jfrog-cred"
                        def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                        def uploadSpec = """{
                            "files": [
                                {
                                "pattern": "jarstaging/(*)",
                                "target": "java-artifacts/{1}",
                                "flat": "false",
                                "props" : "${properties}",
                                "exclusions": [ "*.sha1", "*.md5"]
                                }
                            ]
                        }"""
                        def buildInfo = server.upload(uploadSpec)
                        buildInfo.env.collect()
                        server.publishBuildInfo(buildInfo)
                        echo '<--------------- Jar Publish Ended --------------->'  
                
                }
            }   
        }

        //Adding Docker image build and publish stage
        stage(" Docker Build ") {
            steps {
                script {
                echo '<--------------- Docker Build Started --------------->'
                app = docker.build(imageName+":"+version)
                echo '<--------------- Docker Build Ends --------------->'
                }
            }
        }

        stage (" Docker Publish "){
            steps {
                script {
                echo '<--------------- Docker Publish Started --------------->'  
                    docker.withRegistry(registry, 'jenkins-jfrog-cred'){
                        app.push()
                    }    
                echo '<--------------- Docker Publish Ended --------------->'  
                }
            }
        }
        stage ("Deploy") {
            steps {
                script {
                    echo 'Helm Deploy Started'
                    sh 'helm install <Deployment Name> <Chart Name>'
                }
            }
        }   
    }
}