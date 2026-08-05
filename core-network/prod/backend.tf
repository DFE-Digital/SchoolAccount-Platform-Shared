terraform {
  backend "azurerm" {
    resource_group_name  = "s268p01rg-uks-sa-tfstate"
    storage_account_name = "s268p01sttfstate"
    container_name       = "platform-shared"
    key                  = "core-network.tfstate"
  }
}