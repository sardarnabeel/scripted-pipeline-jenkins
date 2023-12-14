// Jenkinsfile

node {
    stage('Terraform Apply') {
        script {
            // Use AWS SSO login
            sh "aws sso login --profile ${AWS_PROFILE}"

            // Initialize and apply Terraform
            sh 'terraform init'
            sh 'terraform apply -auto-approve'
        }
    }

    def instanceId = sh(script: 'terraform output instance_id', returnStdout: true).trim()

    stage('Stop or Start EC2 Instance') {
        script {
            if (params.STOP_INSTANCE) {
                sh "aws ec2 stop-instances --instance-ids ${instanceId} --region ${AWS_REGION}"
            } else if (params.START_INSTANCE) {
                sh "aws ec2 start-instances --instance-ids ${instanceId} --region ${AWS_REGION}"
            } else {
                echo "No action specified. Please choose either stop or start."
                currentBuild.result = 'FAILURE'
                error("No action specified.")
            }
        }
    }

    stage('Terraform Destroy') {
        script {
            // Destroy resources
            sh 'terraform destroy -auto-approve'
            sh 'rm terraform.tfvars'
        }
    }
}
