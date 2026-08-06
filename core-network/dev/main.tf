module "nsgs" {
  source              = "../../modules/nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  nsgs = {
    ace    = { name = "s268d01-uks-ace-nsg-01" }
    appsvc = { name = "s268d01-uks-appsvc-nsg-01" }
    pe     = { name = "s268d01-uks-pe-nsg-01" }
  }
}

module "subnets" {
  source               = "../../modules/subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnets = {
    ace = {
      name                              = "s268d01-uks-ace-sn-01"
      address_prefixes                  = ["10.226.168.64/26"]
      private_endpoint_network_policies = "Enabled"
      nsg_id                            = module.nsgs.nsg_ids["ace"]
      delegation = {
        name         = "ace-delegation"
        service_name = "Microsoft.App/environments"
        actions      = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
    appsvc = {
      name                              = "s268d01-uks-appsvc-sn-01"
      address_prefixes                  = ["10.226.168.0/27"]
      private_endpoint_network_policies = "Enabled"
      nsg_id                            = module.nsgs.nsg_ids["appsvc"]
      delegation = {
        name         = "appsvc-delegation"
        service_name = "Microsoft.Web/serverFarms"
        actions      = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
    pe = {
      name                              = "s268d01-uks-pe-sn-01"
      address_prefixes                  = ["10.226.168.32/27"]
      private_endpoint_network_policies = "Disabled"
      nsg_id                            = module.nsgs.nsg_ids["pe"]
      delegation                        = null
    }
  }
}