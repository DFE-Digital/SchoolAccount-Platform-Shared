location = "uksouth"

resource_group_name = "s268t05rg-uks-sa-shared"

log_analytics_workspace_name = "s268t05log-sa-shared"

application_insights_name = "s268t05appi-sa-shared"

azure_monitor_workspace_name       = "s268t05amw-sa-shared"
otlp_data_collection_endpoint_name = "s268t05dce-sa-otlp"
otlp_data_collection_rule_name     = "s268t05dcr-sa-otlp"

tags = {
  "Environment"      = "Test"
  "Parent Business"  = "Funding and Allocations"
  "Portfolio"        = "Education and Skills Funding Agency"
  "Product"          = "School Account"
  "Service"          = "Funding and Allocations"
  "Service Line"     = "Funding"
  "Service Offering" = "School Account"
}
