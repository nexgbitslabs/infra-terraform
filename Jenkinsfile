@Library('jenkins-shared-library') _

pipeline {
  agent { label 'linux' }

  options {
    timeout(time: 45, unit: 'MINUTES')
  }

  parameters {
    choice(name: 'ACTION', choices: ['init', 'plan', 'apply', 'destroy'], description: 'Terraform action to perform')
  }

  environment {
    PROPERTIES_FILE = './jenkins-shared-library/infrastructure/terraform/backend-dev.properties'
  }

  stages {
    stage('Init') {
      when {
        expression { params.ACTION == 'init' }
      }
      steps {
        script {
          pipelineDeployWithTerraform([
            propertiesFileName: env.PROPERTIES_FILE,
            jenkinJobInitialAgent: 'linux',
            jenkinsJobTimeOutInMinutes: 45,
            action: 'init'
          ])
        }
      }
    }

    stage('Plan') {
      when {
        expression { params.ACTION == 'plan' }
      }
      steps {
        script {
          pipelineDeployWithTerraform([
            propertiesFileName: env.PROPERTIES_FILE,
            jenkinJobInitialAgent: 'linux',
            jenkinsJobTimeOutInMinutes: 45,
            action: 'plan'
          ])
        }
      }
    }

    stage('Apply') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        script {
          pipelineDeployWithTerraform([
            propertiesFileName: env.PROPERTIES_FILE,
            jenkinJobInitialAgent: 'linux',
            jenkinsJobTimeOutInMinutes: 45,
            action: 'apply'
          ])
        }
      }
    }

    stage('Destroy') {
      when {
        expression { params.ACTION == 'destroy' }
      }
      steps {
        script {
          pipelineDeployWithTerraform([
            propertiesFileName: env.PROPERTIES_FILE,
            jenkinJobInitialAgent: 'linux',
            jenkinsJobTimeOutInMinutes: 45,
            action: 'destroy'
          ])
        }
      }
    }
  }
}
