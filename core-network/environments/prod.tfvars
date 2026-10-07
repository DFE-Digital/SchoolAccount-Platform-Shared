resource_group_name  = "s268p01rg-uks-core"
virtual_network_name = "s268p01-uks-core-vn-01"
location             = "uksouth"

nsgs = {
  appsvc = { name = "s268p01-uks-appsvc-nsg-01" }
  pe     = { name = "s268p01-uks-pe-nsg-01" }
  ace    = { name = "s268p01-uks-ace-nsg-01" }
  mgmt   = { name = "s268p01-uks-mgmt-nsg-01" }
}

# Each subnet is associated with the NSG that has the same key.
subnets = {
  appsvc = {
    name                              = "s268p01-uks-appsvc-sn-01"
    address_prefixes                  = ["10.216.168.0/27"]
    private_endpoint_network_policies = "Enabled"
    delegation = {
      name         = "appsvc-delegation"
      service_name = "Microsoft.Web/serverFarms"
      actions      = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  pe = {
    name                              = "s268p01-uks-pe-sn-01"
    address_prefixes                  = ["10.216.168.32/27"]
    private_endpoint_network_policies = "Disabled"
    delegation                        = null
  }
  ace = {
    name                              = "s268p01-uks-ace-sn-01"
    address_prefixes                  = ["10.216.168.64/26"]
    private_endpoint_network_policies = "Enabled"
    delegation = {
      name         = "ace-delegation"
      service_name = "Microsoft.App/environments"
      actions      = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
  mgmt = {
    name                              = "s268p01-uks-mgmt-sn-01"
    address_prefixes                  = ["10.216.168.224/28"]
    private_endpoint_network_policies = "Enabled"
    delegation                        = null
  }
}
