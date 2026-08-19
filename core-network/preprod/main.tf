module "nsgs" {
  source              = "../../modules/nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  nsgs = {
    appsvc = { name = "s268t05-uks-appsvc-nsg-01" }
    pe     = { name = "s268t05-uks-pe-nsg-01" }
    ace    = { name = "s268t05-uks-ace-nsg-01" }
    mgmt   = { name = "s268505-uks-mgmt-nsg-01" }
  }
}

module "subnets" {
  source               = "../../modules/subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnets = {
    appsvc = {
      name                              = "s268t05-uks-appsvc-sn-01"
      address_prefixes                  = ["10.221.168.0/27"]
      private_endpoint_network_policies = "Enabled"
      nsg_id                            = module.nsgs.nsg_ids["appsvc"]
      delegation = {
        name         = "appsvc-delegation"
        service_name = "Microsoft.Web/serverFarms"
        actions      = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
    pe = {
      name                              = "s268t05-uks-pe-sn-01"
      address_prefixes                  = ["10.221.168.32/27"]
      private_endpoint_network_policies = "Disabled"
      nsg_id                            = module.nsgs.nsg_ids["pe"]
      delegation                        = null
    }
    ace = {
      name                              = "s268t05-uks-ace-sn-01"
      address_prefixes                  = ["10.221.168.64/26"]
      private_endpoint_network_policies = "Enabled"
      nsg_id                            = module.nsgs.nsg_ids["ace"]
      delegation = {
        name         = "ace-delegation"
        service_name = "Microsoft.App/environments"
        actions      = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
    mgmt = {
      name                              = "s268t05-uks-mgmt-sn-01"
      address_prefixes                  = ["10.221.168.224/28"]
      private_endpoint_network_policies = "Enabled"
      nsg_id                            = module.nsgs.nsg_ids["mgmt"]
      delegation                        = null
    }
  }
}