def call(Map config) {
  def props = readProperties file: config.propertiesFileName
  def action = config.action ?: 'plan'

  stage("Terraform ${action.capitalize()}") {
    dir('terraform') {
      sh "terraform init"

      if (action == 'plan') {
        sh "terraform plan -var='location=${props.location}' -var='environment=${props.environment}'"
      } else if (action == 'apply') {
        sh "terraform apply -auto-approve -var='location=${props.location}' -var='environment=${props.environment}'"
      } else if (action == 'destroy') {
        sh "terraform destroy -auto-approve -var='location=${props.location}' -var='environment=${props.environment}'"
      }
    }
  }
}