location           = "canadacentral"
environment        = "dev"
resource_group_name = "my-rg-dev"
subscription_id = "a3fcb44b-8229-4e41-99c5-fbebb9ffb8bf"
storage_account_name = "tfstateaccountnb01"
container_name       = "tfstate-nb01"

vnet_name           = "hub-vnet"
address_space       = ["10.100.0.0/16"]
location            = "eastus"
resource_group_name = "network-rg"

subnets = [
  {
    name                  = "AzureFirewallSubnet"
    address_prefixes      = ["10.100.1.0/24"]
    allowPrivateEndpoints = false
  },
  {
    name                  = "PrivateLinkSubnet"
    address_prefixes      = ["10.100.2.0/24"]
    allowPrivateEndpoints = true
  }
]

pip_name         = "nat-pip"
nat_gw_name      = "nat-gateway"

# pe_name          = "private-endpoint"
# connection_name  = "pe-conn"
# resource_id      = "/subscriptions/.../resourceGroups/xxx/providers/Microsoft.Storage/storageAccounts/xxx"
# subresource_name = "blob"

# dns_zone_name    = "privatelink.blob.core.windows.net"
# kube_vnet_id     = "/subscriptions/.../resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/kube-vnet"

firewall_name    = "fw-main"
firewall_pip_name = "fw-pip"