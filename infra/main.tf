provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../../@libs/jenkins-shared-library/terraform-modules/resource-group"
  name     = "rg-${var.environment}"
  location = var.location
}