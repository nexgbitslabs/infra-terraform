@Library('jenkins-shared-library') _

properties([
  parameters([
    choice(name: 'ENVIRONMENT', choices: ['dev', 'uat', 'prod'], description: 'Deployment environment'),
    string(name: 'PLAYBOOK', defaultValue: 'site.yml', description: 'Playbook to run'),
  ])
])

pipelineDeploy([
  deploymentType: 'ansible',
  environment: params.ENVIRONMENT,
  ansibleRepoUrl: 'https://github.com/nexgbitslabs/infra-ansible.git',
  ansibleRepoBranch: 'main',
  playbook: params.PLAYBOOK
])
