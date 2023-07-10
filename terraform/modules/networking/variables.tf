variable "workload_name" {
  type        = string
  description = "A short name for the workload being deployed"
}

variable "resource_suffix" {
  description = ""
  type        = string
}

variable "location" {
  type        = string
  description = ""
}

variable "deployment_environment" {
  type        = string
  description = "The environment for which the deployment is being executed"

  validation {
    condition     = contains(["dev", "uat", "prod", "dr"], var.deployment_environment)
    error_message = "Valid values for var: deployment_environment are (dev, uat, prod, dr)."
  }
}

variable "apim_cs_vnet_name_address_prefix" {
  type        = string
  description = ""
  default     = "10.2.0.0/25"
}

variable "apim_subnet_address_prefix" {
  type        = string
  description = ""
  default     = "10.2.0.0/27"
}

variable "apim_gw_vnet_name_address_prefix" {
  type        = string
  description = ""
  default     = "10.2.1.0/25"
}

variable "appgateway_subnet_address_prefix" {
  type        = string
  description = ""
  default     = "10.2.1.0/27"
}
