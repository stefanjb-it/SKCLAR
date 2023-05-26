resource "azurerm_app_service_plan" "asp" {
  name = local.appServicePlanName
  resource_group_name = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
  sku {
    tier = "Standard"
    size = local.appServicePlanSize 
  }
}

resource "azurerm_app_service" "as" {
  name = local.appServiceAppName
  resource_group_name = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
  app_service_plan_id = "${resource.azurerm_app_service_plan.asp.id}"
  https_only = true
}