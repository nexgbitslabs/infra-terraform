provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../jenkins-shared-library/modules/resource_group"
  name     = "rg-${var.environment}"
  location = var.location
}