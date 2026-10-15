location = "uksouth"

resource_group_name = "s268p01rg-uks-sa-shared"

log_analytics_workspace_name = "s268p01log-sa-shared"

application_insights_name = "s268p01appi-sa-shared"

app_configuration_name = "s268p01appcs-sa-shared"

azure_monitor_workspace_name       = "s268p01amw-sa-shared"
otlp_data_collection_endpoint_name = "s268p01dce-sa-otlp"
otlp_data_collection_rule_name     = "s268p01dcr-sa-otlp"

tags = {
  "Environment"      = "Prod"
  "Parent Business"  = "Funding and Allocations"
  "Portfolio"        = "Education and Skills Funding Agency"
  "Product"          = "School Account"
  "Service"          = "Funding and Allocations"
  "Service Line"     = "Funding"
  "Service Offering" = "School Account"
}
