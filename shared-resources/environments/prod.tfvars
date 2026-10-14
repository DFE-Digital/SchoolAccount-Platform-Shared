location = "uksouth"

resource_group_name = "s268p01rg-uks-sa-shared"

log_analytics_workspace_name = "s268p01log-sa-shared"

application_insights_name = "s268p01appi-sa-shared"

azure_monitor_workspace_name       = "s268p01amw-sa-shared"
otlp_data_collection_endpoint_name = "s268p01dce-sa-otlp"
otlp_data_collection_rule_name     = "s268p01dcr-sa-otlp"

# System-assigned identity of schoolaccount-web-app (SchoolAccount-Web-Infra).
# Changes if the container app is recreated.
otlp_publisher_principal_ids = {
  "schoolaccount-web-app" = "f827908c-78fa-404e-b538-a163af02d7f6"
}

tags = {
  "Environment"      = "Prod"
  "Parent Business"  = "Funding and Allocations"
  "Portfolio"        = "Education and Skills Funding Agency"
  "Product"          = "School Account"
  "Service"          = "Funding and Allocations"
  "Service Line"     = "Funding"
  "Service Offering" = "School Account"
}
