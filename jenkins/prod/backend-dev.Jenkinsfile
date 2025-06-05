@Library('jenkins-shared-library') _

pipelineDeployWithTerraform([
  action: params.ACTION,
  environment: params.ENVIRONMENT,
  modulePath: params.MODULE_PATH,
  tfRepoUrl: params.TF_REPO_URL,
  tfRepoBranch: params.TF_REPO_BRANCH,
  ansibleRepoUrl: params.ANSIBLE_REPO_URL,
  ansibleRepoBranch: params.ANSIBLE_REPO_BRANCH,
  runAnsible: params.RUN_ANSIBLE,
  terraformWorkingDir: 'infra-terraform',
  terraformVarsFile: "-var-file=tfvars/${params.ENVIRONMENT}.tfvars",
  terraformWorkspace: params.ENVIRONMENT,
  propertiesFileName: "jenkins/${params.ENVIRONMENT}/${params.ENVIRONMENT}.properties",
  jenkinJobInitialAgent: 'linux',
  jenkinsJobTimeOutInMinutes: 45
])
