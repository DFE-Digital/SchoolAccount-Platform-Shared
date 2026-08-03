variable "resource_group_name" {
  type        = string
  description = "Resource group for NSGs"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "nsgs" {
  type = map(object({
    name = string
  }))
  description = "Map of NSGs to create"
}