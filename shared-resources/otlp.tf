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

locals {
  otlp_dcr_path = "datacollectionRules/${azapi_resource.otlp_dcr.output.properties.immutableId}/streams"

  # Published to App Configuration under these keys, unlabelled.
  otlp_endpoints = {
    "otlp-traces-endpoint"  = "${azurerm_monitor_data_collection_endpoint.otlp.logs_ingestion_endpoint}/${local.otlp_dcr_path}/Microsoft-OTLP-Traces/otlp/v1/traces"
    "otlp-logs-endpoint"    = "${azurerm_monitor_data_collection_endpoint.otlp.logs_ingestion_endpoint}/${local.otlp_dcr_path}/Microsoft-OTLP-Logs/otlp/v1/logs"
    "otlp-metrics-endpoint" = "${azurerm_monitor_data_collection_endpoint.otlp.metrics_ingestion_endpoint}/${local.otlp_dcr_path}/Custom-Metrics-Otel/otlp/v1/metrics"
  }
}

# Publish the endpoints to the shared App Configuration store so apps read
# them like any other setting.

data "azurerm_client_config" "current" {}

data "azurerm_app_configuration" "shared" {
  name                = var.app_configuration_name
  resource_group_name = var.resource_group_name
}

# Writing keys is a data-plane action, which the deploying identity's Owner or
# Contributor roles don't cover. Scoped to the store only. A first apply can
# 403 on the keys while the role propagates; re-running fixes it.
resource "azurerm_role_assignment" "deployer_app_config_owner" {
  scope                = data.azurerm_app_configuration.shared.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_app_configuration_key" "otlp" {
  for_each = local.otlp_endpoints

  configuration_store_id = data.azurerm_app_configuration.shared.id
  key                    = each.key
  value                  = each.value

  depends_on = [azurerm_role_assignment.deployer_app_config_owner]
}
