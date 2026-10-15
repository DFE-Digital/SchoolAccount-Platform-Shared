output "otlp_data_collection_rule_id" {
  description = "Resource ID of the OTLP DCR, the scope for Monitoring Metrics Publisher grants"
  value       = azapi_resource.otlp_dcr.id
}

output "otlp_traces_endpoint" {
  description = "OTLP/HTTP traces endpoint"
  value       = local.otlp_endpoints["otlp-traces-endpoint"]
}

output "otlp_logs_endpoint" {
  description = "OTLP/HTTP logs endpoint"
  value       = local.otlp_endpoints["otlp-logs-endpoint"]
}

output "otlp_metrics_endpoint" {
  description = "OTLP/HTTP metrics endpoint"
  value       = local.otlp_endpoints["otlp-metrics-endpoint"]
}
