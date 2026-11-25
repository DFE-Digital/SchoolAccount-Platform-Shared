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

variable "tags" {
  type        = map(string)
  description = "Tags applied to every resource"
}

variable "shared_browser_application_insights_name" {
  type        = string
  description = "Application Insights for browser (client-side) telemetry, kept separate because its connection string is public"
}

variable "shared_browser_application_insights_daily_data_cap_in_gb" {
  type        = number
  description = "Daily ingestion cap for the browser Application Insights, limiting the cost of abuse of its public connection string"
  default     = 1
}
