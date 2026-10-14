output "otlp_data_collection_rule_id" {
  description = "Resource ID of the OTLP DCR, the scope for Monitoring Metrics Publisher grants"
  value       = azapi_resource.otlp_dcr.id
}

output "otlp_traces_endpoint" {
  description = "OTLP/HTTP traces endpoint"
  value       = "${azurerm_monitor_data_collection_endpoint.otlp.logs_ingestion_endpoint}/datacollectionRules/${azapi_resource.otlp_dcr.output.properties.immutableId}/streams/Microsoft-OTLP-Traces/otlp/v1/traces"
}

output "otlp_logs_endpoint" {
  description = "OTLP/HTTP logs endpoint"
  value       = "${azurerm_monitor_data_collection_endpoint.otlp.logs_ingestion_endpoint}/datacollectionRules/${azapi_resource.otlp_dcr.output.properties.immutableId}/streams/Microsoft-OTLP-Logs/otlp/v1/logs"
}

output "otlp_metrics_endpoint" {
  description = "OTLP/HTTP metrics endpoint"
  value       = "${azurerm_monitor_data_collection_endpoint.otlp.metrics_ingestion_endpoint}/datacollectionRules/${azapi_resource.otlp_dcr.output.properties.immutableId}/streams/Custom-Metrics-Otel/otlp/v1/metrics"
}
