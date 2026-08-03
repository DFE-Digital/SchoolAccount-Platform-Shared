output "subnet_ids" {
  value       = { for k, v in azapi_resource.subnet : k => v.id }
  description = "Map of subnet name keys to subnet IDs"
}