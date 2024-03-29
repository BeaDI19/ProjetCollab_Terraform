terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg-maalsi" {
  name     = "rg-${var.project_name}${var.environment_suffix}"
  location = "West Europe"
}



########################
 ## API Web App
########################
resource "azurerm_service_plan" "app-plan" {
    name="plan-${var.project_name}${var.environment_suffix}"
    resource_group_name = data.azurerm_resource_group.rg-maalsi.name
    location = data.azurerm_resource_group.rg-maalsi.location
	sku_name            = "P1v2"
    os_type             = "Linux"  
}

 resource "azurerm_linux_web_app" "web-app" {
  name = "web-${var.project_name}${var.environment_suffix}-v1"
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name
  location = data.azurerm_resource_group.rg-maalsi.location
  service_plan_id = azurerm_service_plan.app-plan.id

  site_config {
	 always_on = true
	 application_stack {
	   node_version = "16-lts"
	 }
  }

}