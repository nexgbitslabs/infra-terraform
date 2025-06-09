variable "location" {
  description = "Location of the network"
  default     = "candacentral"
}

variable "resource_group_name" {
  description = "Size of the VMs"
}

variable "subscription_id" {
   description = "Size of the VMs"
}

variable "storage_account_name" {
   description = "Size of the VMs"
}
variable "container_name" {
   description = "Size of the VMs"
}

variable "hub_vnet_name" {
  description = "value"
  default     = "hub-vnet"
}
variable "nat_gw_name" {
  type        = string
  description = "Name of the NAT Gateway"
}

variable "firewall_name" {
  description = "value"
}

variable "firewall_pip_name" {
  description = "value"
}


variable "prefix" {
  type        = string
  description = "Name of the Public IP Prefix"
}

variable "address_space" {
  description = "value"
}

variable "subnets" {
  description = "Map of subnets for the Hub VNet"
  type        = map(object({
    name             = string
    address_prefixes = list(string)
    service_endpoints = optional(list(string))
    delegation       = optional(object({
      name = string
      service_delegation = object({
        name = string
        actions = list(string)
      })
    }))
  }))
}

variable "dns_servers" {
  description = "DNS servers for the VNet"
  type        = map(string)
  default     = {}
}
variable "environment" {
  description = "value"
}
# variable "connection_name" {
#   type = string
# }

# variable "resource_id" {
#   type = string
# }

# variable "subresource_names" {
#   type        = list(string)
#   description = "List of subresource names to connect to (e.g., ['blob'], ['vault'])"
# }