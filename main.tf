# VNET MODULE
module "resource_group" {
  source              = "./modules/resource_group"
  name                = var.resource_group_name
  location            = var.location
  environment         = var.environment
}

module "hub_vnet" {
  source              = "./modules/vnet"  # or wherever the vnet module is stored
  hub_vnet_name       = var.hub_vnet_name
  hub_vnet_address_space  = var.hub_vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  subnets             = var.subnets
  environment         = var.environment
  dns_servers         = var.dns_servers

  depends_on = [ module.resource_group ]
}

# NAT GATEWAY MODULE
module "nat_gateway" {
  source              = "./modules/nat_gateway"
  pip_name            = var.pip_name
  nat_gw_name         = var.nat_gw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.hub_vnet.subnet_ids["AzureFirewallSubnet"]
  environment         = var.environment



  depends_on = [ module.hub_vnet ]
}

# PRIVATE ENDPOINT MODULE
# module "private_endpoint" {
#   source                        = "./modules/private_endpoint"
#   name                          = "example-pe"
#   location                      = var.location
#   resource_group_name           = var.resource_group_name
#   subnet_id                     = var.subnet_id
#   connection_name               = "example-connection"
#   resource_id                   = var.storage_account_id
#   subresource_names             = ["blob"]  # ✅ MUST BE A LIST

#   depends_on = [ module.hub_vnet ]
# }

# PRIVATE DNS ZONE MODULE
resource "azurerm_private_dns_zone" "privatednszone" {
  name                = "nexgbitsacademy.com"
  resource_group_name = var.resource_group_name
}

# FIREWALL MODULE
module "firewall" {
  source              = "./modules/firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  firewall_name       = var.firewall_name
  firewall_pip_name   = var.firewall_pip_name
  firewall_subnet_id = var.firewall_subnet_id

  depends_on = [ module.hub_vnet ]
}