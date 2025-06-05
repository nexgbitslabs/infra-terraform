@Library('jenkins-shared-library') _

pipelineDeployWithTerraform([
  terraformWorkingDir: 'infra-terraform',
  terraformWorkspace: 'dev',
  action: 'plan',
  terraformVarsFile: '-var-file=infra-terraform/tfvars/dev.tfvars',
  propertiesFileName: 'infra-terraform/jenkins/dev/dev.properties',
  jenkinJobInitialAgent: 'linux',
  jenkinsJobTimeOutInMinutes: 45
])

