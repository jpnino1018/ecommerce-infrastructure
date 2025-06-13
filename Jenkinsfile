pipeline {
    agent any

    tools {
        terraform 'terraform-tool'
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'stage', 'prod'], description: 'Select environment to deploy')
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure instead of apply')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                withCredentials([azureServicePrincipal('azure-credentials')]) {
                    dir("envs/${params.ENV}") {
                        sh '''
                            export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                            export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                            export ARM_TENANT_ID=$AZURE_TENANT_ID
                            export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID

                            terraform init -input=false
                            terraform plan -out=tfplan -input=false -var-file="${ENV}.tfvars"
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply/Destroy') {
            steps {
                withCredentials([azureServicePrincipal('azure-credentials')]) {
                    dir("envs/${params.ENV}") {
                        script {
                            def tfCmd = params.DESTROY ?
                                'terraform destroy -auto-approve -var-file="${ENV}.tfvars"' :
                                'terraform apply -input=false tfplan'

                            sh """
                                export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                                export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                                export ARM_TENANT_ID=$AZURE_TENANT_ID
                                export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID

                                ${tfCmd}
                            """
                        }
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }
    }
}
