output "terraform_state_resource_group_name" {
  value = azurerm_resource_group.tf-state-rg.name
}
output "terraform_state_storage_account" {
  value = azurerm_storage_account.storage-account.name
}
output "terraform_state_storage_account_key" {
    value = azurerm_storage_account.storage-account.primary_access_key
}
output "terraform_state_storage_container_core" {
  value = azurerm_storage_container.core-container.name
}
output "config_backend_azure" {
  value = "${local.config_backend_azure}"
}

// terraform backend setting
locals {
  config_backend_azure = <<CONFIGBACKENDS3

# follow the below instructions
# 1. save this output into main.tf like below
# tf output config_backend_azure > main.tf
# 2. save the storage account key as ARM_ACCESS_KEY
# export ARM_ACCESS_KEY=$(tf output terraform_state_storage_account_key)

terraform {
  backend "azurerm" {
  resource_group_name = ${azurerm_resource_group.tf-state-rg.name}
  storage_account_name = ${azurerm_storage_account.storage-account.name}
  container_name = ${azurerm_storage_container.core-container.name}
  # Name key name as you want
  key = "${var.project}-${var.env}-tfstate"
  }
}

// provider
provider "azurerm" {
  features {}
}

CONFIGBACKENDS3
}