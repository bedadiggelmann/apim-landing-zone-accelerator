terraform {

  backend "azurerm" {
    # ----------------------
    # Will be passing in these arguments via CLI as the state file \
    #  is now being overwritten via local testing environments
    # > https://developer.hashicorp.com/terraform/language/settings/backends/configuration#command-line-key-value-pairs
    # ----------------------
    # e.g: terraform init \
    #        -backend-config="resource_group_name=rg-terraform"     \
    #        -backend-config="storage_account_name=apimlztfbackend" \
    #        -backend-config="container_name=terraform-state"       \
    #        -backend-config="key=es-apim-lza.tfstate"
    # ----------------------
    resource_group_name  = "rg-apim-eslz-terraform-backend"
    storage_account_name = "stapimeslz"
    container_name       = "terraformbackend"
    access_key           = "oYYQd/chBchoaMX0U1m+QOCmqRXyiF2EDYi5KWDjsQkYUrnUMx368soDtu/iMabiCULWWC9mMq7G+AStHIa3Mg=="
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1"
    }
  }
}

# Configure the Microsft Azure provider
provider "azurerm" {
  features {}

  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
}
