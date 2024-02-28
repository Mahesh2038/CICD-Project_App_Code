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
                sh 'mvn clean deploy'
            }
        }
        stage('SonarQube code analysis') {
            environment {
                scannerHome = tool 'mk-sonarqube-scanner'  // Define sonar scanner in Env variable.
            }
            steps {
                withSonarQubeEnv('mk-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner" //This will communicate with SonarQube server and send analysis report.
                }
            }
        }
    }
}