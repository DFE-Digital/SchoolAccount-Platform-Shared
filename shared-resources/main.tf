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

# Browser (client-side) telemetry is kept in its own Application Insights
# resource because its connection string is shipped to every browser and is
# effectively public. Keeping it separate means server telemetry can't be
# spoofed or polluted through it, and the daily cap limits the cost of abuse.
resource "azurerm_application_insights" "shared_browser" {
  name                = var.shared_browser_application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = data.azurerm_log_analytics_workspace.shared.id

  # The JavaScript SDK can only send with the connection string, so local
  # (key-based) authentication must stay enabled on this resource.
  local_authentication_enabled = true

  daily_data_cap_in_gb                 = var.shared_browser_application_insights_daily_data_cap_in_gb
  daily_data_cap_notifications_enabled = true

  tags = merge(var.tags, {
    "Telemetry" = "Browser"
  })

  lifecycle {
    prevent_destroy = true
  }
}
