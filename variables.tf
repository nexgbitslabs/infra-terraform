variable "subscriptionid" {}
variable "environment" {
  description = "Gets added as a tag to identify the deployment as production, development or test"
}
variable "prefix" {
  description = "Many named items will be prefixed with this value to prevent duplication"
}
variable "location" {
  description = "The resource group location"
}
variable "resource_group_name" {
  description = "name of the keyvault to be created to store the names of each tenant keyvault"
}

variable "hub_vnet_name" {
  description = "Hub VNET name"
  default     = "vnet-hub"
}
