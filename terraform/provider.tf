terraform {

  backend "azurerm" {
    resource_group_name  = "rg-apim-eslz-terraform-backend"
    storage_account_name = "stapimeslz"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1"
    }
  }
}

# Configure the Microsft Azure provider (Service Principal)
provider "azurerm" {
  features {}
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
}
