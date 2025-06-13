pipeline {
    agent any

    tools {
        terraform 'terraform-tool' // Name you gave it in the UI
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'stage', 'prod'], description: 'Select environment to deploy')
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure instead of apply')
    }

    environment {
        TF_IN_AUTOMATION     = 'true'
        ARM_CLIENT_ID        = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET    = credentials('ARM_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID  = credentials('ARM_SUBSCRIPTION_ID')
        ARM_TENANT_ID        = credentials('ARM_TENANT_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir("envs/${params.ENV}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("envs/${params.ENV}") {
                    sh 'terraform plan -out=tfplan -input=false'
                }
            }
        }

        stage('Terraform Apply/Destroy') {
            steps {
                dir("envs/${params.ENV}") {
                    script {
                        if (params.DESTROY) {
                            sh 'terraform destroy -auto-approve'
                        } else {
                            sh 'terraform apply -input=false tfplan'
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                cleanWs()
            }
        }
    }
}
