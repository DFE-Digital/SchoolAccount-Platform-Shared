# Backend values are supplied per environment at init time:
#
#   terraform init -reconfigure -backend-config=environments/<env>.backend.hcl
#
# Each environment has its own tfstate storage account in its own subscription.
terraform {
  backend "azurerm" {}
}
