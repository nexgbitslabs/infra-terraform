@Library('jenkins-shared-library') _

properties([
  parameters([
    choice(name: 'TYPE', choices: ['terraform', 'aks', 'ansible', 'apim'], description: 'Deployment type'),
    string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Deployment environment'),
    string(name: 'MODULE_PATH', defaultValue: 'resource-group', description: 'Deployment module path'),
    string(name: 'REPO_URL', defaultValue: 'https://github.com/nexgbitslabs/infra-terraform.git', description: 'Git repo URL for deployment'),
    string(name: 'REPO_BRANCH', defaultValue: 'main', description: 'Branch of the repo to checkout'),
    string(name: 'ACTION', defaultValue: 'plan', description: 'Terraform action'),
    booleanParam(name: 'CHECKOUT_SHARED_LIBRARY', defaultValue: true, description: 'Checkout shared library into workspace?'),
    string(name: 'SHARED_LIBRARY_URL', defaultValue: 'https://github.com/nexgbitslabs/jenkins-shared-library.git', description: 'Shared library repo URL'),
    string(name: 'SHARED_LIBRARY_BRANCH', defaultValue: 'main', description: 'Branch of the shared library')
  ])
])

pipelineDeploy(
  type: params.TYPE,
  environment: params.ENVIRONMENT,
  modulePath: params.MODULE_PATH,
  repoUrl: params.REPO_URL,
  tfRepoBranch: params.REPO_BRANCH,
  action: params.ACTION,
  checkoutSharedLibrary: params.CHECKOUT_SHARED_LIBRARY,
  sharedLibraryUrl: params.SHARED_LIBRARY_URL,
  sharedLibraryBranch: params.SHARED_LIBRARY_BRANCH
)
