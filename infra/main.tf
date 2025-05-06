provider "azurerm" {
  subscription_id = var.subscription
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.project}-${var.environment}-${var.location}-001"
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${substr(sha256("rg-${var.project}-${var.environment}-${var.location}-001"), 0, 24)}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "asp-${var.project}-${var.environment}-${var.location}-001"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "function_app" {
  name                = "lfa-${var.project}-${var.environment}-${var.location}-001"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
    http2_enabled = true
  }

  app_settings = {
    "GITHUB_TOKEN": "${var.githubtoken}"
  }
}
