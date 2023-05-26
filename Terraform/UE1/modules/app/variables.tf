variable "resource_group_name" {
  type = string
  description = "The name of the ressource group for deployment"
}

variable "resource_group_id" {
  type = string
  description = "The id of the ressource group for deployment"
}

variable "resource_group_location" {
  type = string
  description = "The location of the ressource group for deployment"
}

variable "environment" {
  type = string
}

locals {
    appServiceAppName =  join("",["asa", substr(sha256("${var.resource_group_id}"),0,15)])
    appServicePlanName = join("",["asp", substr(sha256("${var.resource_group_id}"),0,15)])
    appServicePlanSize = var.environment == "prod" ? "P2v3" : "F1"
}