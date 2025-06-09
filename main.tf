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
      name : "subnet-agents_devops"
      address_prefixes : ["10.100.0.16/28"]
      allowPrivateEndpoints : false
    }
  ]
}

# First NAT Gateway to provide enough source NAT ports to the cluster's node pools
module "nat_gateway_hub" {
  source          = "./modules/nat_gateway"
  location        = var.location
  resource_group  = var.resource_group_name
  pip_prefix_name = "pip-prefix-nat-gw-hub"
  nat_gw_name     = "nat-gw-hub"
  subnet_id       = module.hub_vnet.subnet_ids["AzureFirewallSubnet"]
}

resource "azurerm_public_ip" "ingress_lb_public_ip" {
  name                = "${var.prefix}_Ingress_PublicIp"
  #Resource group that contains the cluster resources created by Azure
  resource_group_name = "MC_${azurerm_resource_group.spoke.name}_${azurerm_kubernetes_cluster.private_aks_cluster.name}_${var.location}"
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
  depends_on = [azurerm_kubernetes_cluster.private_aks_cluster]
}


#to check the permissions to resources at subscriptions level, the identity needs the reader role in the IAM of the agent VM 
resource "azurerm_role_assignment" "devops_agent_identity" {
 role_definition_name = "Reader"
 scope                = module.devops_agent.vm_id
 principal_id         = module.devops_agent.agent_identity_sp_id
 depends_on           = [module.devops_agent]
}

resource "azurerm_role_assignment" "devops_agent_mtlo_identity" {
 role_definition_name = "Reader"
 scope                = module.devops_agent_mtlo.vm_id
 principal_id         = module.devops_agent_mtlo.agent_identity_sp_id
 depends_on           = [module.devops_agent]
}


resource "azurerm_resource_group" "dns" {
  name     = "${var.prefix}-${var.resource_group_name}"
  location = var.location
}



# resource "azurerm_resource_group" "this" {
#   name = var.resource_group_name
#   location = var.location
# }

# resource "azurerm_virtual_network" "vnet" {
#   name                = "test"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   address_space       = ["10.0.0.0/16"]
# }

# resource "azurerm_subnet" "apim-subnet" {
#   name                 = "apim-vnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_subnet" "main-subnet" {
#   name                 = "main-vnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.3.0/24"]
# }

# resource "azurerm_public_ip" "this" {
#   name                = "test"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   allocation_method = "Dynamic"
#   sku                 = "Basic"
# }
