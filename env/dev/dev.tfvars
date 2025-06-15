location           = "canadacentral"
environment        = "dev"
resource_group_name = "my-rg-dev"
subscription_id = "a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf"
storage_account_name = "tfstateaccountnb01"
container_name       = "tfstate-nb01"

hub_vnet_name = "hub-vnet"
hub_vnet_address_space       = ["10.100.0.0/16"]
subnets = {
  AzureFirewallSubnet = {
    address_prefixes      = ["10.100.1.0/24"]
    allowPrivateEndpoints = false
  },
  PrivateLinkSubnet = {
    address_prefixes      = ["10.100.2.0/24"]
    allowPrivateEndpoints = true
  }
}
dns_servers = {
  primary   = "8.8.8.8"
  secondary = "8.8.4.4"
}
pip_name         = "nat-pip"
nat_gw_name      = "nat-gateway"

# pe_name          = "private-endpoint"
# connection_name  = "pe-conn"
# resource_id      = "/subscriptions/.../resourceGroups/xxx/providers/Microsoft.Storage/storageAccounts/xxx"
# subresource_name = "blob"
# dns_zone_name    = "privatelink.blob.core.windows.net"
# kube_vnet_id     = "/subscriptions/.../resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/kube-vnet"
prefix                = "pip-dev-prefix"
firewall_name    = "fw-main"
firewall_pip_name = "fw-pip"
firewall_subnet_id = "/subscriptions/a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf/resourceGroups/my-rg-dev/providers/Microsoft.Network/virtualNetworks/hub-vnet/subnets/AzureFirewallSubnet"

# infra_resource_group_name       = "rg-events"
# location                  = "canadacentral"
# namespace_name            = "evh-namespace-dev"

# cluster_name              = "evh-cluster"
# cluster_sku               = "Dedicated"

# eventhub_name             = "my-eventhub"
# partition_count           = 4
# message_retention         = 3

# consumer_group_name       = "cg-payments"
# user_metadata             = "Used by payments team"

# schema_group_name         = "schema-group1"
# schema_group_properties   = {
#   compatibility = "Forward"
#   schema_type   = "Avro"
# }

infra_resource_group_name = "rg-events"
location                  = "canadacentral"
namespace_name            = "evh-namespace-dev"
namespace_sku             = "Standard"
namespace_capacity        = 1
namespace_zone_redundant  = false
namespace_auto_inflate_enabled = true
namespace_maximum_throughput_units = 4
tags = {
  environment = "dev"
  team        = "eventing"
}

cluster_name              = "evh-cluster"
cluster_sku               = "Dedicated"

eventhub_name             = "my-eventhub"
partition_count           = 4
message_retention         = 3

consumer_group_name       = "cg-payments"
user_metadata             = "Used by payments team"

schema_group_name         = "schema-group1"
schema_group_properties   = {
  compatibility = "Forward"
  schema_type   = "Avro"
}


