def registry = 'http://192.168.33.12:8082/'
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
    }
}