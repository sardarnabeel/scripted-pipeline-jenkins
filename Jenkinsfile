node {
    parameters {
        string(name: 'AWS_PROFILE', defaultValue: 'your-sso-profile', description: 'AWS SSO Profile')
        string(name: 'AWS_REGION', defaultValue: 'your-aws-region', description: 'AWS Region')
        booleanParam(name: 'STOP_INSTANCE', defaultValue: false, description: 'Stop EC2 Instance')
        booleanParam(name: 'START_INSTANCE', defaultValue: false, description: 'Start EC2 Instance')
        string(name: 'TF_VAR_instance_type', defaultValue: 't2.micro', description: 'EC2 Instance Type for Terraform')
        string(name: 'TF_VAR_ami', defaultValue: 'ami-0c55b159cbfafe1f0', description: 'AMI for Terraform')
    }

    // Set AWS SSO credentials
    sh "aws sso login --profile ${params.AWS_PROFILE}"

    // Prompt for Terraform variables
    sh "echo 'TF_VAR_instance_type=${params.TF_VAR_instance_type}' > terraform.tfvars"
    sh "echo 'TF_VAR_ami=${params.TF_VAR_ami}' >> terraform.tfvars"

    // Terraform Apply
    sh 'terraform init'
    sh 'terraform apply -auto-approve'

    def instanceId

    // Stop or Start EC2 Instance
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

    // Terraform Destroy
    sh 'terraform destroy -auto-approve'
    sh 'rm terraform.tfvars'
}
