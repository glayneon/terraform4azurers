# Generate a random storage name
resource "random_string" "tf-name" {
  length = 8
  upper = false
  number = true
  lower = true
  special = false
}

# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}
// provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf-state-rg" {
  name     = var.tfstate_rg
  location = var.region
  
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    owner  = var.owner
    project = var.project
    env    = "${lower(var.project)}-${var.env}"
  }
}

# Create a Storage Account for the Terraform State File
resource "azurerm_storage_account" "storage-account" {
  depends_on = [azurerm_resource_group.tf-state-rg]
 
  name = "${lower(var.project)}tfstate${random_string.tf-name.result}"
  resource_group_name = azurerm_resource_group.tf-state-rg.name
  location = var.region
  account_kind = "StorageV2"
  account_tier = "Standard"
  access_tier = "Hot"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
   
  lifecycle {
    prevent_destroy = false
  }
  
  tags = {
    owner  = var.owner
    project = var.project
    env    = "${lower(var.project)}-${var.env}"
  }
}

# Create a Storage Container for the Core State File
resource "azurerm_storage_container" "core-container" {
  depends_on = [azurerm_storage_account.storage-account]
  
  name                 = "${lower(var.project)}-${lower(var.env)}-tfstate"
  storage_account_name = azurerm_storage_account.storage-account.name
}