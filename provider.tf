terraform {
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
}
