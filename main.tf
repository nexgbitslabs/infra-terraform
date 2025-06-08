######CUSTOM CONFIGURATION FOR THE PROD ENVIRONMENT#####

#to take the azure tenant id from the current session
data "azurerm_client_config" "current" {}


#RESOURCE GROUP CREATION
resource "azurerm_resource_group" "hub" {
  name     = "${var.prefix}-${var.hub_resource_group_name}"
  location = var.location
}

resource "azurerm_resource_group" "spoke" {
  name     = "${var.prefix}-${var.aks_resource_group_name}"
  location = var.location
}

resource "azurerm_resource_group" "vaults" {
  name     = "${var.prefix}-${var.vaults_resource_group_name}"
  location = var.location
}


#NETWORK COMPONENTS CREATION
module "hub_vnet" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.hub.name
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

module "spoke_vnet_aks" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = var.location
  vnet_name           = var.spoke_vnet_name
  address_space       = [var.vnet_spoke_address_space]
  subnets = [
    {
      name : "subnet-cluster"
      address_prefixes : [var.subnet_cluster]
      allowPrivateEndpoints : true
    },
    {
      name : "subnet-ingress"
      address_prefixes : [var.subnet_ingress]
      allowPrivateEndpoints : false
    }
  ]
}

module "vnets_peering" {
  source              = "./modules/vnet_peering"
  vnet_1_name         = var.hub_vnet_name
  vnet_1_id           = module.hub_vnet.vnet_id
  vnet_1_rg           = azurerm_resource_group.hub.name
  vnet_2_name         = var.spoke_vnet_name
  vnet_2_id           = module.spoke_vnet_aks.vnet_id
  vnet_2_rg           = azurerm_resource_group.spoke.name
  peering_name_1_to_2 = "HubToSpoke"
  peering_name_2_to_1 = "SpokeToHub"
}

#First NAT Gateway to provide enough source NAT ports to the cluster's node pools
module "nat_gateway_hub" {
  source          = "./modules/nat_gateway"
  location        = var.location
  resource_group  = azurerm_resource_group.hub.name
  pip_prefix_name = "pip-prefix-nat-gw-hub"
  nat_gw_name     = "nat-gw-hub"
  subnet_id       = module.hub_vnet.subnet_ids["AzureFirewallSubnet"]
}

# Second NAT Gateway to provide internet access to the ingress node pool only
module "nat_gateway_spoke" {
  source          = "./modules/nat_gateway"
  location        = var.location
  resource_group  = azurerm_resource_group.spoke.name
  pip_prefix_name = "pip-prefix-nat-gw-spoke"
  nat_gw_name     = "nat-gw-spoke"
  subnet_id       = module.spoke_vnet_aks.subnet_ids["subnet-ingress"]
}
# An empty route table should be always associated to the ingress subnet
resource "azurerm_route_table" "rt_ingress" {
  name                = "routetable-ingress"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
}
resource "azurerm_subnet_route_table_association" "aks_subnet_ingress_association" {
  subnet_id      = module.spoke_vnet_aks.subnet_ids["subnet-ingress"]
  route_table_id = azurerm_route_table.rt_ingress.id
}

module "firewall" {
  source               = "./modules/firewall"
  resource_group       = azurerm_resource_group.hub.name
  location             = var.location
  pip_name             = "ip-firewall-hub"
  fw_name              = "firewall-hub"
  fw_policy_name       = "firewall-hub-policy"
  fw_rcg_name          = "firewall-hub-rcg"
  subnet_id            = module.hub_vnet.subnet_ids["AzureFirewallSubnet"]
  rabbitmq_fqdn        = var.rabbitmq_fqdn
  subnet_cluster_space = var.subnet_cluster
  depends_on           = [module.nat_gateway_hub]
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
