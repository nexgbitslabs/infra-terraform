# VNET MODULE
module "resource_group" {
  source              = "./modules/vnet"
  name                = var.resource_group_name
  location            = var.location
}

module "hub_vnet" {
  source              = "./modules/vnet"
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  subnets             = var.subnets

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
module "private_dns_zone" {
  source              = "./modules/private_dns_zone"
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  vnet_ids            = {
    hub_vnet = module.hub_vnet.vnet_id
  }

  depends_on = [ module.hub_vnet ]
}

# FIREWALL MODULE
module "firewall" {
  source              = "./modules/firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_name           = var.vnet_name
  subnet_id           = module.hub_vnet.subnet_ids["AzureFirewallSubnet"]
  firewall_name       = var.firewall_name
  public_ip_name      = var.firewall_pip_name

  depends_on = [ module.hub_vnet ]
}