# Brings the Application Insights created by the SchoolAccount-DevOps shared ARM template under
# Terraform in each environment. Remove this file once the import has been applied everywhere.
import {
  to = azurerm_application_insights.shared
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/components/${var.application_insights_name}"
}
