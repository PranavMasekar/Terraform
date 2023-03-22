pipeline {
    agent any
    stages {
        stage("Provision Infrastructure") {
            steps {
                echo 'PROVISIONING'
                sh 'terraform init'
                sh 'terraform plan'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}