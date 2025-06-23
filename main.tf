#VNET MODULE
module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "infra_resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.infra_resource_group_name
  location            = var.location
}

module "hub_vnet" {
  source              = "./modules/vnet"  # or wherever the vnet module is stored
  hub_vnet_name       = var.hub_vnet_name
  hub_vnet_address_space  = var.hub_vnet_address_space
  location            = var.location
  resource_group_name = var.infra_resource_group_name
  subnets             = var.subnets
  environment         = var.environment
  dns_servers         = var.dns_servers
  security_gp_name    = var.security_gp_name

  depends_on = [ module.resource_group, infra_resource_group ]
}

# NAT GATEWAY MODULE
module "nat_gateway" {
  source              = "./modules/nat_gateway"
  pip_name            = var.pip_name
  nat_gw_name         = var.nat_gw_name
  location            = var.location
  resource_group_name = var.infra_resource_group_name
  subnet_id           = module.hub_vnet.subnet_ids["AzureFirewallSubnet"]
  environment         = var.environment
  depends_on = [ module.hub_vnet, infra_resource_group ]
}
