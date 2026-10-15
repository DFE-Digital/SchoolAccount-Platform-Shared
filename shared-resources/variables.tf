variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Shared resource group name"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Shared Log Analytics workspace name, still created by the shared ARM template"
}

variable "application_insights_name" {
  type        = string
  description = "Shared Application Insights name"
}

variable "app_configuration_name" {
  type        = string
  description = "Shared App Configuration store the OTLP endpoints are published to"
}

variable "azure_monitor_workspace_name" {
  type        = string
  description = "Azure Monitor workspace name, the destination for OTLP metrics"
}

variable "otlp_data_collection_endpoint_name" {
  type        = string
  description = "Data Collection Endpoint name for OTLP ingestion"
}

variable "otlp_data_collection_rule_name" {
  type        = string
  description = "Data Collection Rule name for OTLP ingestion"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to every resource"
}
