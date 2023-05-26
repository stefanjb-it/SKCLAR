terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.57.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
    name = "CLINF-GL_Joebstl"
}

resource "azurerm_storage_account" "sa" {
  name                     = local.storageAccountName
  resource_group_name      = "${data.azurerm_resource_group.rg.name}"
  location                 = "${data.azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = local.storageAccountReplicationTier
}

module "app" {
  source = "./modules/app"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  resource_group_id = "${data.azurerm_resource_group.rg.id}"
  resource_group_location = "${data.azurerm_resource_group.rg.location}"
  environment = var.environmentType
}