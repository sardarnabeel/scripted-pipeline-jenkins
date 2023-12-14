// node {
//     // Define parameters
//     properties([
//         parameters([
//             string(name: 'AWS_REGION', description: 'AWS Region', defaultValue: 'your-aws-region', trim: true),
//             string(name: 'AWS_PROFILE', description: 'AWS CLI Profile (SSO user)', defaultValue: 'your-aws-profile', trim: true),
//             booleanParam(name: 'STOP_INSTANCE', description: 'Stop EC2 Instance', defaultValue: false),
//             booleanParam(name: 'START_INSTANCE', description: 'Start EC2 Instance', defaultValue: false)
//         ])
//     ])

//     // Terraform script
//     stage('Terraform Apply') {
//         steps {
//             script {
//                 // Initialize Terraform
//                 sh 'terraform init'

//                 // Apply Terraform configuration
//                 sh 'terraform apply -auto-approve'

//                 // Capture the instance ID from Terraform output
//                 def instanceId = sh(script: 'terraform output -raw instance_id', returnStdout: true).trim()
//                 echo "Captured Instance ID: ${instanceId}"

//                 // login with AWS SSO
//                 sh "aws sso login --profile ${params.AWS_PROFILE}"

//                 // Check if either STOP_INSTANCE or START_INSTANCE is selected
//                 if (params.STOP_INSTANCE) {
//                     echo "Stopping EC2 instance: ${instanceId}"
//                     sh "aws ec2 stop-instances --instance-ids ${instanceId} --region ${params.AWS_REGION} --output json --profile ${params.AWS_PROFILE}"
//                 } else if (params.START_INSTANCE) {
//                     echo "Starting EC2 instance: ${instanceId}"
//                     sh "aws ec2 start-instances --instance-ids ${instanceId} --region ${params.AWS_REGION} --output json --profile ${params.AWS_PROFILE}"
//                 } else {
//                     echo "No action specified. Please choose either stop or start."
//                     currentBuild.result = 'FAILURE'
//                     error("No action specified.")
//                 }
//             }
//         }
//     }
// }
node {
    // Define parameters
    def AWS_REGION = 'us-east-1'
    def AWS_PROFILE = 'nabeel'
    def STOP_INSTANCE = false
    def START_INSTANCE = false

    // Terraform script
    stage('Terraform Apply') {
        // Initialize Terraform
        sh 'terraform init'

        // Apply Terraform configuration
        sh 'terraform apply -auto-approve'

        // Capture the instance ID from Terraform output
        def instanceId = sh(script: 'terraform output -raw instance_id', returnStdout: true).trim()
        echo "Captured Instance ID: ${instanceId}"

        // login with AWS SSO
        sh "aws sso login --profile ${AWS_PROFILE}"

        // Check if either STOP_INSTANCE or START_INSTANCE is selected
        if (STOP_INSTANCE) {
            echo "Stopping EC2 instance: ${instanceId}"
            sh "aws ec2 stop-instances --instance-ids ${instanceId} --region ${AWS_REGION} --output json --profile ${AWS_PROFILE}"
        } else if (START_INSTANCE) {
            echo "Starting EC2 instance: ${instanceId}"
            sh "aws ec2 start-instances --instance-ids ${instanceId} --region ${AWS_REGION} --output json --profile ${AWS_PROFILE}"
        } else {
            echo "No action specified. Please choose either stop or start."
            currentBuild.result = 'FAILURE'
            error("No action specified.")
        }
    }
}
