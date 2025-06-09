######CUSTOM CONFIGURATION FOR THE PROD ENVIRONMENT#####

#to take the azure tenant id from the current session
data "azurerm_client_config" "current" {}


#RESOURCE GROUP CREATION
#NETWORK COMPONENTS CREATION
module "hub_vnet" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.hub_vnet_name
  address_space       = ["10.100.0.0/16"]
  subnets = [
    {
      # DO NOT change this name; *must* be called AzureFirewallSubnet
      name : "AzureFirewallSubnet"
      address_prefixes : ["10.100.50.0/24"]
      allowPrivateEndpoints : false
    },
    {
      name : "subnet-jumpbox"
      address_prefixes : ["10.100.0.0/28"]
      allowPrivateEndpoints : false
    },
    {
      name : "apim"
      address_prefixes : ["10.100.10.0/28"]
      allowPrivateEndpoints : false
    },
    {
      name : "subnet-agents_devops"
      address_prefixes : ["10.100.0.16/28"]
      allowPrivateEndpoints : false
    }
  ]
}

#First NAT Gateway to provide enough source NAT ports to the cluster's node pools
module "nat_gateway_hub" {
  source          = "./modules/nat_gateway"
  location        = var.location
  resource_group  = var.resource_group_name
  pip_prefix_name = "pip-prefix-nat-gw-hub"
  nat_gw_name     = "nat-gw-hub"
  subnet_id       = module.hub_vnet.subnet_ids["AzureFirewallSubnet"]
}

# Second NAT Gateway to provide internet access to the ingress node pool only
module "nat_gateway_spoke" {
  source          = "./modules/nat_gateway"
  location        = var.location
  resource_group  = var.resource_group_name
  pip_prefix_name = "pip-prefix-nat-gw-spoke"
  nat_gw_name     = "nat-gw-spoke"
  subnet_id       = module.spoke_vnet_aks.subnet_ids["subnet-ingress"]
}
# An empty route table should be always associated to the ingress subnet
resource "azurerm_route_table" "rt_ingress" {
  name                = "routetable-ingress"
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet_route_table_association" "aks_subnet_ingress_association" {
  subnet_id      = module.spoke_vnet_aks.subnet_ids["subnet-ingress"]
  route_table_id = azurerm_route_table.rt_ingress.id
}
