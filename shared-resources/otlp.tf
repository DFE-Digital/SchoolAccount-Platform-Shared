# OTLP ingestion into Azure Monitor, wired to the shared Application Insights.
#
# Traces and logs land in the shared Log Analytics workspace, metrics in an
# Azure Monitor workspace. Based on Microsoft's manual orchestration template:
# https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/opentelemetry-protocol-ingestion

data "azurerm_resource_group" "shared" {
  name = var.resource_group_name
}

resource "azurerm_monitor_workspace" "shared" {
  name                = var.azure_monitor_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_monitor_data_collection_endpoint" "otlp" {
  name                          = var.otlp_data_collection_endpoint_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  description                   = "Data Collection Endpoint for OTLP telemetry"
  public_network_access_enabled = true

  tags = var.tags
}

# azurerm_monitor_data_collection_rule has no otelLogs/otelTraces/otelMetrics
# data sources, so the DCR is managed through azapi.
resource "azapi_resource" "otlp_dcr" {
  type      = "Microsoft.Insights/dataCollectionRules@2024-03-11"
  name      = var.otlp_data_collection_rule_name
  location  = var.location
  parent_id = data.azurerm_resource_group.shared.id

  body = {
    properties = {
      description              = "OTLP telemetry sent directly by OpenTelemetry SDKs or Collectors"
      dataCollectionEndpointId = azurerm_monitor_data_collection_endpoint.otlp.id

      references = {
        applicationInsights = [
          {
            resourceId = azurerm_application_insights.shared.id
            name       = "applicationInsightsResource"
          }
        ]
      }

      directDataSources = {
        otelMetrics = [
          {
            name                         = "otelMetricsDataSourceDirect"
            streams                      = ["Custom-Metrics-Otel"]
            enrichWithResourceAttributes = ["*"]
            enrichWithReference          = "applicationInsightsResource"
          }
        ]
        otelLogs = [
          {
            name                           = "otelLogsDataSourceDirect"
            streams                        = ["Microsoft-OTel-Logs"]
            enrichWithResourceAttributes   = ["*"]
            enrichWithReference            = "applicationInsightsResource"
            replaceResourceIdWithReference = true
          }
        ]
        otelTraces = [
          {
            name = "otelTracesDataSourceDirect"
            streams = [
              "Microsoft-OTel-Traces-Spans",
              "Microsoft-OTel-Traces-Events",
              "Microsoft-OTel-Traces-Resources",
            ]
            enrichWithResourceAttributes   = ["*"]
            enrichWithReference            = "applicationInsightsResource"
            replaceResourceIdWithReference = true
          }
        ]
      }

      destinations = {
        monitoringAccounts = [
          {
            name              = "azureMonitorWorkspace"
            accountResourceId = azurerm_monitor_workspace.shared.id
          }
        ]
        logAnalytics = [
          {
            name                = "logAnalyticsWorkspace"
            workspaceResourceId = data.azurerm_log_analytics_workspace.shared.id
          }
        ]
      }

      dataFlows = [
        {
          streams      = ["Custom-Metrics-Otel"]
          destinations = ["azureMonitorWorkspace"]
        },
        {
          streams = [
            "Microsoft-OTel-Logs",
            "Microsoft-OTel-Traces-Spans",
            "Microsoft-OTel-Traces-Events",
            "Microsoft-OTel-Traces-Resources",
          ]
          destinations = ["logAnalyticsWorkspace"]
        }
      ]
    }
  }

  response_export_values = ["properties.immutableId"]

  tags = var.tags
}

resource "azurerm_role_assignment" "otlp_publisher" {
  for_each = var.otlp_publisher_principal_ids

  scope                = azapi_resource.otlp_dcr.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = each.value

  skip_service_principal_aad_check = true
}
