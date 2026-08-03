data "azurerm_client_config" "current" {}

resource "azapi_resource" "subnet" {
  for_each = var.subnets

  type      = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
  name      = each.value.name
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network_name}"

  body = jsonencode({
    properties = {
      addressPrefix = each.value.address_prefixes[0]
      networkSecurityGroup = each.value.nsg_id != null ? {
        id = each.value.nsg_id
      } : null
      privateEndpointNetworkPolicies = each.value.private_endpoint_network_policies
      delegations = each.value.delegation != null ? [
        {
          name = each.value.delegation.name
          properties = {
            serviceName = each.value.delegation.service_name
          }
        }
      ] : []
    }
  })
}