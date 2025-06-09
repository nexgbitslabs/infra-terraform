location           = "canadacentral"
environment        = "dev"
resource_group_name = "my-rg-dev"
subscription_id = "a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf"
storage_account_name = "tfstateaccountnb01"
container_name       = "tfstate-nb01"
prefix="nbdev"
vnet_name=""
address_space = ""
name = ""
subnet_id = ""
subresource_names = ""
private_dns_zone_id = ""
subnets_map = {
  "subnet-app" = {
    address_prefixes      = ["10.0.1.0/24"]
    allowPrivateEndpoints = true
  },
  "subnet-db" = {
    address_prefixes      = ["10.0.2.0/24"]
    allowPrivateEndpoints = false
  },
  "subnet-monitoring" = {
    address_prefixes      = ["10.0.3.0/24"]
    allowPrivateEndpoints = true
  }
}
private_connection_resource_id = ""
private_dns_zone_name = ""
pip_prefix_name = ""
nat_gw_name = ""
# private_dns_vnet_links = {
#   hub-vnet  = "/subscriptions/xxxx/resourceGroups/rg-hub-network/providers/Microsoft.Network/virtualNetworks/vnet-hub"
#   aks-vnet  = "/subscriptions/xxxx/resourceGroups/rg-aks-network/providers/Microsoft.Network/virtualNetworks/vnet-aks"
# }