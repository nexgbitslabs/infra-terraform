provider "azurerm" {
  features {}

   subscription_id = var.subscription_id
}

module "resource_group" {
  source   = "../../../@libs/jenkins-shared-library/modules/resource_group"
  name     = "rg-${var.environment}"
  location = var.location
}