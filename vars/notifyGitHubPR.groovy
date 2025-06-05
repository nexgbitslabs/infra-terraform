def notifyGitHubPR(String message) {
    if (!env.CHANGE_ID || !env.CHANGE_URL) {
        echo "⚠️ Not a PR build. Skipping GitHub notification."
        return
    }

    if (!env.GIT_URL) {
        echo "⚠️ GIT_URL not found. Cannot determine repo."
        return
    }

    def prNumber = env.CHANGE_ID
    def repoUrl = env.GIT_URL.replaceAll(/\.git$/, '')
    def repoParts = repoUrl.tokenize('/')
    def owner = repoParts[-2]
    def repo = repoParts[-1]
    def apiUrl = "https://api.github.com/repos/${owner}/${repo}/issues/${prNumber}/comments"

    // Escape the message properly to prevent JSON/command-line issues
    def escapedMessage = message.replace('"', '\\"').replace('\n', '\\n')

    withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB_TOKEN')]) {
        sh """
        curl -s -X POST "${apiUrl}" \\
             -H "Authorization: token ${GITHUB_TOKEN}" \\
             -H "Content-Type: application/json" \\
             -d "{ \\"body\\": \\"${escapedMessage}\\" }"
        """
    }
}
