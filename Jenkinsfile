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
                sh 'mvn clean install'
            }
        }
    }
}