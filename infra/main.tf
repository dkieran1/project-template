provider "azurerm" {
  subscription_id = var.subscription
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.project}-${var.environment}-resource-group"
  location = var.location
}

resource "azurerm_storage_account" "resource_group" {
  name                     = var.storagename
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "resource_group" {
  name                = "${var.project}-${var.environment}-app-service-plan"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "resource_group" {
  name                = "${var.project}-function-app"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location

  storage_account_name       = azurerm_storage_account.resource_group.name
  storage_account_access_key = azurerm_storage_account.resource_group.primary_access_key
  service_plan_id            = azurerm_service_plan.resource_group.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
    http2_enabled = true
    cors {
      allowed_origins = ["*"]
    }
  }
}