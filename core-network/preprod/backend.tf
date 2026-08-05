terraform {
  backend "azurerm" {
    resource_group_name  = "s268t05rg-uks-sa-tfstate"
    storage_account_name = "s268t05sttfstate"
    container_name       = "platform-shared"
    key                  = "core-network.tfstate"
  }
}