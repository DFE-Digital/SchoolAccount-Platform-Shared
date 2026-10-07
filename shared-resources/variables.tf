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
