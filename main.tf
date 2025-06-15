data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
  scope = data.azurerm_subscription.current.id
}

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

  depends_on = [ module.resource_group ]
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
  depends_on = [ module.hub_vnet ]
}




module "assign_contributor_role" {
  source = "./modules/roles_and_permissions"
  scope = data.azurerm_subscription.current.id

  role_assignments = {
    "Contributor" = [
      {
        principal_id = data.azurerm_client_config.current.object_id
        description  = "Assign Contributor role to current user"
      }
    ]
  }
}

# PRIVATE DNS ZONE MODULE
resource "azurerm_private_dns_zone" "privatednszone" {
  name                = "nexgbitsacademy.com"
  resource_group_name = var.infra_resource_group_name
}

# FIREWALL MODULE
module "firewall" {
  source              = "./modules/firewall"
  location            = var.location
  resource_group_name = var.infra_resource_group_name
  firewall_name       = var.firewall_name
  firewall_pip_name   = var.firewall_pip_name
  firewall_subnet_id = var.firewall_subnet_id
  sku_tier           = var.sku_tier
  sku_name           = var.sku_name

  depends_on = [ module.hub_vnet ]
}

module "eventhub_cluster" {
  source              = "./modules/eventhub_resources/eventhub_cluster"
  cluster_name         = var.cluster_name
  resource_group_name = var.infra_resource_group_name
  location            = var.location
  sku_name            = "Dedicated_1"
}

module "eventhub_namespace" {
  source                  = "./modules/eventhub_resources/namespaces"
  namespace_name          = var.namespace_name
  resource_group_name     = var.infra_resource_group_name
  location                = var.location
  sku                     = var.namespace_sku
  capacity                = var.namespace_capacity
  zone_redundant          = var.namespace_zone_redundant
  auto_inflate_enabled    = var.namespace_auto_inflate_enabled
  maximum_throughput_units = var.namespace_maximum_throughput_units
  tags                    = var.tags
}

module "eventhub" {
  source        = "./modules/eventhub_resources/eventhub"
  name          = "my-eventhub"
  namespace_id  = module.eventhub_namespace.id  # <- ✅ this must be a full resource ID
  partition_count   = 2
  message_retention = 7
  status            = "Active"
  capture_description = null
  tags              = { environment = "dev" }
}

module "consumer_group" {
  source              = "./modules/eventhub_resources/eventhub_consumer_groups"
  name                = var.consumer_group_name
  namespace_id        = module.eventhub_namespace.id
  eventhub_name       = var.eventhub_name
  resource_group_name = var.resource_group_name
  user_metadata       = var.user_metadata
  location            = var.location
}

module "schema_group" {
  source              = "./modules/eventhub_resources/eventhub_namespace_schema"
  name                = var.schema_group_name
  namespace_id        = module.eventhub_namespace.id 
}

module "assign_contributor_role_schema" {
  source = "./modules/roles_and_permissions"
  scope  = data.azurerm_subscription.current.id

  role_assignments = {
    "Contributor" = [
      {
        principal_id    = data.azurerm_client_config.current.object_id
        user_name       = "CurrentUser"
        description     = "Assign Contributor role to current user"
      }
    ]
  }
}

