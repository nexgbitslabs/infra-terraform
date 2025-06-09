# VNET MODULE
module "hub_vnet" {
  source              = "./modules/vnet"
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  subnets             = var.subnets
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
module "private_endpoint" {
  source                = "./modules/private_endpoint"
  pe_name               = var.pe_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  subnet_id             = module.hub_vnet.subnet_ids["PrivateLinkSubnet"]
  connection_name       = var.connection_name
  resource_id           = var.resource_id
  subresource_name      = var.subresource_name

  depends_on = [ module.hub_vnet ]
}

# PRIVATE DNS ZONE MODULE
# module "private_dns_zone" {
#   source              = "./modules/private_dns_zone"
#   name                = var.dns_zone_name
#   resource_group_name = var.resource_group_name
#   vnet_ids            = {
#     hub_vnet  = module.hub_vnet.vnet_id
#     kube_vnet = var.kube_vnet_id
#   }
# }

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