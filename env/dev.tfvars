location           = "canadacentral"
environment        = "dev"
resource_group_name = "my-rg-dev"
subscription_id = "a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf"
storage_account_name = "tfstateaccountnb01"
container_name       = "tfstate-nb01"
key                  = "dev.terraform.tfstate"

### SUBSCRIPTIONS VARIABLES ###
prefix="nbdev"
certificate_keyvault_id="/subscriptions/a548cb3d-0887-4b87-8460-6bf34967538b/resourceGroups/cbmtdev-shared/providers/Microsoft.KeyVault/vaults/cbmtVaultDev"
shared_resource_group_name = "cbmtdev-shared"
shared_keyvault_id="/subscriptions/a548cb3d-0887-4b87-8460-6bf34967538b/resourceGroups/cbmtdev-shared/providers/Microsoft.KeyVault/vaults/cbmt-vault-dev"
vaults_names_keyvault="vaultsNamesDev"
### APP GATEWAY HOSTNAMES & CERTIFICATES ###
# primary_hostname="*.dev.ongsx.com"
# secondary_hostname="*.partner.dev.ongsx.com"
# primary_cert_name="dev-ongsx-com"
# secondary_cert_name="test-self-signed"


### NETWORK VARIABLES ###
#network_service_cidr in variables.tf should be equal in network size to subnet_cluster variable here
vnet_spoke_address_space="10.240.0.0/16"
subnet_cluster="10.240.0.0/17"
subnet_postgres="10.240.200.0/24"
subnet_ingress="10.240.250.0/24"
subnet_app_gw="10.240.254.0/24"
### IP OF THE INGRESS CONTROLLER FOR APP GW IN CBMT, THIS SHOULD BELONG TO THE SAME SUBNET_CLUSTER TO BE ABLE TO COMMUNICATE WITH THE PODS, 
### THE INGRESS PODS WILL TAKE THE IP ADDRESS OF THE INGRESS SUBNET AND THE SERVICE IN THE NAMESPACE WILL TAKE THIS IP AS EXTERNAL
# ingress_controller_ip="10.240.100.101"
### CLUSTER & KEYVAULTS ADMIN VARIABLES ###

### SQL VARIABLES
### LIST OF SQL ELASTIC POOLS TO BE CREATED IN THE ENVIRONMENT
