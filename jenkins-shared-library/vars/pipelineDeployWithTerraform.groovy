import groovy.json.JsonSlurper

def call(Map config) {
    pipeline {
        agent { label "${config.jenkinJobInitialAgent ?: 'linux'}" }

        options {
            timeout(time: config.jenkinsJobTimeOutInMinutes ?: 30, unit: 'MINUTES')
        }

        environment {
            PROP_FILE = "1.0-terraformtopfolder/${config.propertiesFileName}"
        }

        stages {
            stage('Load Properties') {
                steps {
                    script {
                        def props = readProperties file: env.PROP_FILE
                        props.each { key, value -> env."${key}" = value }
                        echo "✔️ Loaded properties from ${env.PROP_FILE}"
                    }
                }
            }

            stage('Azure Login') {
                steps {
                    withCredentials([string(credentialsId: 'AZURE_SP_CREDENTIALS', variable: 'AZURE_SP_JSON')]) {
                        script {
                            def json = new JsonSlurper().parseText(env.AZURE_SP_JSON)
                            sh """
                            az login --service-principal \
                              --username "${json.clientId}" \
                              --password "${json.clientSecret}" \
                              --tenant "${json.tenantId}"
                            az account set --subscription "${json.subscriptionId}"
                            echo "🔐 Azure login successful"
                            """
                        }
                    }
                }
            }

            stage('Terraform Init') {
                steps {
                    sh '''
                    terraform init \
                      -backend-config="storage_account_name=$TF_VAR_backend_storage_account" \
                      -backend-config="container_name=$TF_VAR_backend_container" \
                      -backend-config="key=$TF_VAR_backend_key"
                    '''
                }
            }

            stage('Terraform Plan') {
                steps {
                    sh '''
                    terraform plan \
                      -var="environment=$TF_VAR_environment" \
                      -var="region=$TF_VAR_region" \
                      -var="resource_group_name=$TF_VAR_resource_group_name"
                    '''
                }
            }

            stage('Terraform Apply') {
                when {
                    expression { return env.TF_VAR_environment == 'dev' }
                }
                steps {
                    input message: "Apply changes to DEV?"
                    sh '''
                    terraform apply -auto-approve \
                      -var="environment=$TF_VAR_environment" \
                      -var="region=$TF_VAR_region" \
                      -var="resource_group_name=$TF_VAR_resource_group_name"
                    '''
                }
            }

            stage('GitHub Metadata') {
                steps {
                    script {
                        echo "🧠 Git Info"
                        echo "Branch: ${env.BRANCH_NAME ?: 'N/A'}"
                        echo "Commit: ${env.GIT_COMMIT ?: 'N/A'}"
                        echo "Repo: ${env.GIT_URL ?: 'N/A'}"
                    }
                }
            }
        }

        post {
            success {
                echo "✅ Pipeline succeeded for ${env.TF_VAR_environment}"
                // Optional: GitHub notification here
            }
            failure {
                echo "❌ Pipeline failed."
            }
        }
    }
}

def notifyGitHubPR(String message) {
    if (!env.CHANGE_ID || !env.CHANGE_URL) {
        echo "⚠️ Not a PR build. Skipping GitHub notification."
        return
    }

    def prNumber = env.CHANGE_ID
    def repoUrl = env.GIT_URL?.replaceAll(/\.git$/, '')
    def repoParts = repoUrl.tokenize('/')
    def owner = repoParts[-2]
    def repo = repoParts[-1]

    def apiUrl = "https://api.github.com/repos/${owner}/${repo}/issues/${prNumber}/comments"

    withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB_TOKEN')]) {
        sh """
        curl -s -X POST ${apiUrl} \\
             -H "Authorization: token ${GITHUB_TOKEN}" \\
             -H "Content-Type: application/json" \\
             -d '{ "body": "${message}" }'
        """
    }
}