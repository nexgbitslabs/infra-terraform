def call(Map config) {
  def props = readProperties file: config.propertiesFileName
  def action = config.action ?: 'plan'
  def tfDir = config.terraformWorkingDir ?: 'terraform'
  def tfvars = config.terraformVarsFile ?: ''
  def workspace = config.terraformWorkspace ?: props.environment

  stage("Terraform ${action.capitalize()}") {
    dir(tfDir) {

      // Init with backend config
      sh "terraform init"

      // Select or create workspace
      if (workspace) {
        sh """
          terraform workspace list | grep -q '${workspace}' || terraform workspace new '${workspace}'
          terraform workspace select '${workspace}'
        """
      }

      // Execute Terraform actions
      if (action == 'plan') {
        sh "terraform plan ${tfvars} -var='location=${props.location}' -var='environment=${props.environment}' -out=plan.out"
      } else if (action == 'apply') {
        sh "terraform apply -auto-approve ${tfvars} -var='location=${props.location}' -var='environment=${props.environment}'"
      } else if (action == 'destroy') {
        sh "terraform destroy -auto-approve ${tfvars} -var='location=${props.location}' -var='environment=${props.environment}'"
      } else if (action == 'init') {
        echo "Terraform initialized only. No plan/apply/destroy executed."
      } else {
        error "Unsupported action: ${action}"
      }
    }
  }
}
