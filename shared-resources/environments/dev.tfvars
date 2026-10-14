location = "uksouth"

resource_group_name = "s268d01rg-uks-sa-shared"

log_analytics_workspace_name = "s268d01log-sa-shared"

application_insights_name = "s268d01appi-sa-shared"

azure_monitor_workspace_name       = "s268d01amw-sa-shared"
otlp_data_collection_endpoint_name = "s268d01dce-sa-otlp"
otlp_data_collection_rule_name     = "s268d01dcr-sa-otlp"

# System-assigned identity of schoolaccount-web-app (SchoolAccount-Web-Infra).
# Changes if the container app is recreated.
otlp_publisher_principal_ids = {
  "schoolaccount-web-app" = "85c46486-f1d0-4d52-8318-413e7757aa38"
}

tags = {
  "Environment"      = "Dev"
  "Parent Business"  = "Funding and Allocations"
  "Portfolio"        = "Education and Skills Funding Agency"
  "Product"          = "School Account"
  "Service"          = "Funding and Allocations"
  "Service Line"     = "Funding"
  "Service Offering" = "School Account"
}
