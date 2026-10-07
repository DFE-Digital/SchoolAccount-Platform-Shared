data "azurerm_log_analytics_workspace" "shared" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_application_insights" "shared" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = data.azurerm_log_analytics_workspace.shared.id

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}
