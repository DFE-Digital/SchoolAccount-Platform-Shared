variable "resource_group_name" {
  type        = string
  description = "Network resource group name"
}

variable "virtual_network_name" {
  type        = string
  description = "VNet name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "nsgs" {
  type = map(object({
    name = string
  }))
  description = "NSGs to create, keyed by the subnet they protect"
}

variable "subnets" {
  type = map(object({
    name                              = string
    address_prefixes                  = list(string)
    private_endpoint_network_policies = optional(string, "Enabled")
    delegation = optional(object({
      name         = string
      service_name = string
      actions      = list(string)
    }))
  }))
  description = "Subnets to add to the VNet. Each is associated with the NSG that has the same key"
}
