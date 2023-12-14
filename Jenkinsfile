// Jenkinsfile

node {
    stage('Terraform Apply') {
        withCredentials([string(credentialsId: 'aws-sso-credentials', variable: 'AWS_SSO_CREDS')]) {
            withAWS(region: 'us-east-1', credentials: 'nabeel') {
                sh '''
                    echo "${AWS_SSO_CREDS}" > terraform.tfvars
                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }
    }

    def instanceId = sh(script: 'terraform output instance_id', returnStdout: true).trim()

    stage('Stop or Start EC2 Instance') {
        withAWS(region: 'us-east-1', credentials: 'nabeel') {
            if (params.STOP_INSTANCE) {
                sh "aws ec2 stop-instances --instance-ids ${instanceId} --region us-east-1"
            } else if (params.START_INSTANCE) {
                sh "aws ec2 start-instances --instance-ids ${instanceId} --region us-east-1"
            } else {
                echo "No action specified. Please choose either stop or start."
                currentBuild.result = 'FAILURE'
                error("No action specified.")
            }
        }
    }

    stage('Terraform Destroy') {
        withCredentials([string(credentialsId: 'aws-sso-credentials', variable: 'AWS_SSO_CREDS')]) {
            withAWS(region: 'us-east-1', credentials: 'nabeel') {
                sh '''
                    terraform destroy -auto-approve
                    rm terraform.tfvars
                '''
            }
        }
    }
}
