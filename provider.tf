terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"  # Adjust to the latest stable major version (as of mid-2025)
    }
  }
}

provider "azurerm" {
  features {}
}