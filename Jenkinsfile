
D** Jenkinsfile content.
@Library('jenkins-shared-library') _

properties([
  parameters([
    choice(name: 'ACTION', choices: ['init', 'plan', 'apply', 'destroy'], description: 'Terraform action to perform'),
    choice(name: 'ENVIRONMENT', choices: ['dev', 'uat', 'prod'], description: 'Deployment environment'),
    string(name: 'MODULE_PATH', defaultValue: 'infra/backend', description: 'Terraform module path'),
  ])
])

pipelineDeploy([
  deploymentType: 'terraform',
  action: params.ACTION,
  environment: params.ENVIRONMENT,
  modulePath: params.MODULE_PATH,
  repoUrl: 'https://github.com/nexgbitslabs/infra-terraform.git',
  tfRepoBranch: 'main'
])