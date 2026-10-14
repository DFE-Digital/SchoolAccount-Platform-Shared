location = "uksouth"

resource_group_name = "s268d01rg-uks-sa-shared"

log_analytics_workspace_name = "s268d01log-sa-shared"

application_insights_name = "s268d01appi-sa-shared"

azure_monitor_workspace_name       = "s268d01amw-sa-shared"
otlp_data_collection_endpoint_name = "s268d01dce-sa-otlp"
otlp_data_collection_rule_name     = "s268d01dcr-sa-otlp"

tags = {
  "Environment"      = "Dev"
  "Parent Business"  = "Funding and Allocations"
  "Portfolio"        = "Education and Skills Funding Agency"
  "Product"          = "School Account"
  "Service"          = "Funding and Allocations"
  "Service Line"     = "Funding"
  "Service Offering" = "School Account"
}
