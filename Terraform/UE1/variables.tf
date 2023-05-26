variable "environmentType" {
    type = string
    description = "The variable defines the enviroment the file is deployed to."
    validation {
        condition = var.environmentType == "prod" || var.environmentType == "nonprod"
        error_message = "The value must be prod or nonprod."
    }
}

locals {
    storageAccountName = join("",["sa", substr(sha256("${data.azurerm_resource_group.rg.id}"),0,15)])
    storageAccountReplicationTier = var.environmentType == "prod" ? "GRS" : "LRS"
}