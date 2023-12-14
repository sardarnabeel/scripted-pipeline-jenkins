/////////////////////////////////////////////////////////////////////////////
node {
    parameters {
        string(name: 'AWS_PROFILE', defaultValue: 'your-sso-profile', description: 'AWS SSO Profile')
        string(name: 'AWS_REGION', defaultValue: 'your-aws-region', description: 'AWS Region')
        booleanParam(name: 'STOP_INSTANCE', defaultValue: false, description: 'Stop EC2 Instance')
        booleanParam(name: 'START_INSTANCE', defaultValue: false, description: 'Start EC2 Instance')
    }

    stage('Set AWS SSO credentials') {
        steps {
            script {
                // Use AWS SSO login
                sh "aws sso login --profile ${params.AWS_PROFILE}"
            }
        }
    }

    stage('Terraform Apply') {
        steps {
            script {
                // Initialize and apply Terraform
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
    }

    def instanceId

    stage('Stop or Start EC2 Instance') {
        steps {
            script {
                instanceId = sh(script: 'terraform output instance_id', returnStdout: true).trim()

                if (params.STOP_INSTANCE) {
                    sh "aws ec2 stop-instances --instance-ids ${instanceId} --region ${params.AWS_REGION}"
                } else if (params.START_INSTANCE) {
                    sh "aws ec2 start-instances --instance-ids ${instanceId} --region ${params.AWS_REGION}"
                } else {
                    echo "No action specified. Please choose either stop or start."
                    currentBuild.result = 'FAILURE'
                    error("No action specified.")
                }
            }
        }
    }

    stage('Terraform Destroy') {
        steps {
            script {
                // Destroy resources
                sh 'terraform destroy -auto-approve'
                sh 'rm terraform.tfvars'
            }
        }
    }
}
