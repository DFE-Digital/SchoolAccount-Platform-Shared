module "nsgs" {
  source              = "../modules/nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  nsgs                = var.nsgs
}

module "subnets" {
  source               = "../modules/subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnets = {
    for key, subnet in var.subnets : key => merge(subnet, {
      nsg_id = module.nsgs.nsg_ids[key]
    })
  }
}
