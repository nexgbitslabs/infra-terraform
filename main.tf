
module "resource_group" {
  source   = "./modules/resource_group"
  name     = "rg-${var.environment}"
  location = var.location
  environment = var.environment
}