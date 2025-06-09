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
  description = "value"
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