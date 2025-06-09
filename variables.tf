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
variable "shared_resource_group_name" {
  description = "name of the shared resource group name of the environment"
}
variable "shared_keyvault_id" {
  description = "Environment's shared keyvault created and variables filled before running the Terraform"
}
variable "vaults_names_keyvault" {
  description = "name of the keyvault to be created to store the names of each tenant keyvault"
}

variable "hub_resource_group_name" {
  description = "The resource group name to be created"
  default     = "hub"
}
variable "aks_resource_group_name" {
  description = "The resource group name to be created"
  default     = "spoke-aks"
}
variable "nbdev_resource_group_name" {
  description = "The resource group name to be created"
  default     = "spoke-aks"
}
variable "vaults_resource_group_name" {
  description = "The resource group name to be created"
  default     = "vaults"
}

variable "hub_vnet_name" {
  description = "Hub VNET name"
  default     = "vnet-hub"
}

variable "createsharedkeyvault" {
  description = "choose if to create or not"
  type = bool
  
  default = false
}