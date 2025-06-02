@Library('jenkins-shared-library') _

pipeline {
  agent { label 'linux' }

  options {
    timeout(time: 45, unit: 'MINUTES')
  }

  parameters {
    choice(name: 'ACTION', choices: ['init', 'plan', 'apply', 'destroy'], description: 'Terraform action to perform')
    choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Deployment environment')
    string(name: 'TF_REPO_URL', defaultValue: 'https://github.com/nexgbitslabs/infra-terraform.git', description: 'Terraform Git repo URL')
    string(name: 'TF_REPO_BRANCH', defaultValue: 'main', description: 'Terraform Git branch')
    string(name: 'ANSIBLE_REPO_URL', defaultValue: 'https://github.com/nexgbitslabs/infra-ansible.git', description: 'Ansible Git repo URL')
    string(name: 'ANSIBLE_REPO_BRANCH', defaultValue: 'main', description: 'Ansible Git branch')
    booleanParam(name: 'RUN_ANSIBLE', defaultValue: true, description: 'Run Ansible playbook after Terraform apply?')
  }

  environment {
    TF_REPO_DIR = 'terraform'
    ANSIBLE_REPO_DIR = 'ansible'
    WORKSPACE_NAME = "${params.ENVIRONMENT}"
  }

  stages {

    stage('Validate Branches') {
      steps {
        script {
          sh "git ls-remote --heads ${params.TF_REPO_URL} ${params.TF_REPO_BRANCH} || exit 1"
          sh "git ls-remote --heads ${params.ANSIBLE_REPO_URL} ${params.ANSIBLE_REPO_BRANCH} || exit 1"
        }
      }
    }

    stage('Clone Terraform Repo') {
      steps {
        dir("${TF_REPO_DIR}") {
          git url: params.TF_REPO_URL, branch: params.TF_REPO_BRANCH
        }
      }
    }

    stage('Clone Ansible Repo') {
      steps {
        dir("${ANSIBLE_REPO_DIR}") {
          git url: params.ANSIBLE_REPO_URL, branch: params.ANSIBLE_REPO_BRANCH
        }
      }
    }

    stage('Terraform Action') {
      steps {
        script {
          def tfvars = ''
          def tfvarsFile = findFiles(glob: "${TF_REPO_DIR}/*.tfvars").firstOrNull()
          if (tfvarsFile) {
            tfvars = "-var-file=${tfvarsFile.path}"
          }

          pipelineDeployWithTerraform([
            propertiesFileName: "${TF_REPO_DIR}/backend-${params.ENVIRONMENT}.properties",
            terraformWorkingDir: TF_REPO_DIR,
            terraformWorkspace: WORKSPACE_NAME,
            terraformVarsFile: tfvars,
            jenkinJobInitialAgent: 'linux',
            jenkinsJobTimeOutInMinutes: 45,
            action: params.ACTION
          ])
        }
      }
    }

    stage('Archive Terraform Outputs') {
      when {
        anyOf {
          expression { params.ACTION == 'plan' }
          expression { params.ACTION == 'apply' }
        }
      }
      steps {
        dir("${TF_REPO_DIR}") {
          script {
            sh '''
              cp -f terraform.tfstate terraform.tfstate.${ENVIRONMENT} || true
              cp -f plan.out plan.out.${ENVIRONMENT} || true
            '''
            archiveArtifacts artifacts: 'terraform/terraform.tfstate*', allowEmptyArchive: true
            archiveArtifacts artifacts: 'terraform/plan.out*', allowEmptyArchive: true
          }
        }
      }
    }

    stage('Run Ansible Playbook') {
      when {
        allOf {
          expression { params.ACTION == 'apply' }
          expression { params.RUN_ANSIBLE == true }
        }
      }
      steps {
        dir("${ANSIBLE_REPO_DIR}") {
          sh '''
            echo "Running Ansible Playbook..."
            ansible-playbook -i inventory.ini site.yml
          '''
        }
      }
    }
  }
}
