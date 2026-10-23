terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sec_rg" {
  name     = "rg-devsecops-prod"
  location = "westeurope"
}

resource "azurerm_storage_account" "sec_storage" {
  name                            = "stdevsecopsprod001"
  resource_group_name             = azurerm_resource_group.sec_rg.name
  location                        = azurerm_resource_group.sec_rg.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  
  # [TEST 5 - CHECKOV IaC]: Aşağıdaki değerleri "TLS1_0" veya true yaparsan Checkov hattı durdurur!
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}