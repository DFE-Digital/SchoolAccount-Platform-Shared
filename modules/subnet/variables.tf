variable "resource_group_name" {
  type        = string
  description = "Name of the resource group containing the VNet"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the VNet to add subnets to"
}

variable "subnets" {
  type = map(object({
    name                               = string
    address_prefixes                   = list(string)
    private_endpoint_network_policies  = optional(string, "Enabled")
    nsg_id                             = optional(string, null)
    delegation                         = optional(object({
      name         = string
      service_name = string
      actions      = list(string)
    }))
  }))
}