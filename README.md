# jenkins-shared-library
### Creating the service principle

```
az ad sp create-for-rbac --name "jenkins-sp" \
--role contributor \
--scopes /subscriptions/<YOUR_SUBSCRIPTION_ID> \
--sdk-auth
``` 

#### Important commands
`eval "$(ssh-agent -s)"
ssh-add ~/.ssh/nexgbitslabspem
`