properties([
    parameters([
        string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS Region'),
        string(name: 'AWS_PROFILE', defaultValue: 'nabeel', description: 'AWS Profile'),
        choice(name: 'ACTION', choices: ['start', 'stop'], description: 'Select action: start or stop')
    ])
])

node {
    // Define parameters
    def AWS_REGION = params.AWS_REGION
    def AWS_PROFILE = params.AWS_PROFILE
    def ACTION = params.ACTION

    // Checkout the repository
    checkout scm

    // Set the path to the Terraform files directory
    def terraformPath = "${env.WORKSPACE}"

    // Terraform script
    stage('Terraform Apply') {
        // Navigate to the Terraform files directory
        dir(terraformPath) {
            // Initialize Terraform
            sh 'terraform init'

            // Apply Terraform configuration
            sh 'terraform apply -auto-approve'

            // Capture the instance ID from Terraform output
            def instanceId = sh(script: 'terraform output -raw instance_id', returnStdout: true).trim()
            echo "Captured Instance ID: ${instanceId}"

            // login with AWS SSO
            sh "aws sso login --profile ${AWS_PROFILE}"

            // Perform the specified action based on the parameter
            if (ACTION == 'stop') {
                echo "Stopping EC2 instance: ${instanceId}"
                sh "aws ec2 stop-instances --instance-ids ${instanceId} --region ${AWS_REGION} --output json --profile ${AWS_PROFILE}"
            } else if (ACTION == 'start') {
                echo "Starting EC2 instance: ${instanceId}"
                sh "aws ec2 start-instances --instance-ids ${instanceId} --region ${AWS_REGION} --output json --profile ${AWS_PROFILE}"
            } else {
                echo "Invalid action specified. Please choose either 'start' or 'stop'."
                currentBuild.result = 'FAILURE'
                error("Invalid action specified.")
            }
        }
    }
}

