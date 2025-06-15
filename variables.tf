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

variable "sku_tier" {
   description = "Size of the VMs"
}

variable "sku_name" {
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

variable "firewall_pip_name" {
  description = "value"
}


variable "prefix" {
  type        = string
  description = "Name of the Public IP Prefix"
}

variable "hub_vnet_address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "subnets" {
  type = map(object({
    address_prefixes      = list(string)
    allowPrivateEndpoints = bool
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

variable "pip_name" {
  description = "Name of the public IP used by the NAT gateway"
  type        = string
}

variable "firewall_name" {
  description = "value"
}

variable "firewall_subnet_id" {
  description = "value"
  type = string
}
variable "infra_resource_group_name" {}
variable "infra_location" {}
variable "namespace_name" {}
variable "namespace_sku" {}
variable "namespace_capacity" { default = null }
variable "namespace_zone_redundant" { 
  type = bool 
  default = false 
  }
variable "namespace_auto_inflate_enabled" { 
  type = bool 
default = false 
}
variable "namespace_maximum_throughput_units" { 
  type = number 
default = null 
}
variable "tags" { 
  type = map(string) 
default = {} 
}

variable "eventhub_name" {}
variable "partition_count" { default = 2 }
variable "message_retention" { default = 1 }

variable "consumer_group_name" {}
variable "user_metadata" { default = null }

variable "schema_group_name" {}
variable "schema_group_properties" {
  type = map(string)
}

#----------Role Assignment--------------
variable "scope" {
  description = "The Azure scope for role assignments."
  type        = string
}

variable "role_assignments" {
  description = "Map of role names to list of assignment objects."
  type = map(list(object({
    principal_id                        = string
    user_name                         = optional(string)
    group_name                        = optional(string)
    serviceprincipal_name             = optional(string)
    description                      = optional(string)
    privileged_access_validation_enabled = optional(bool, true)
    condition                       = optional(string)
  })))
}
