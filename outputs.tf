output "agent_public_ip" {
 value = "${module.devops_agent_mtlo.agent_ip}"
}

output "vaults_rg_name"{
  description = "name of the resource group for the clients vaults"
  value = azurerm_resource_group.vaults.name
}

