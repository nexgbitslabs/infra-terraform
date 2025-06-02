
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