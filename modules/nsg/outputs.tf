output "nsg_ids" {
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
  description = "Map of NSG name keys to NSG IDs"
}