variable "workload_name" {
  type        = string
  description = "A short name for the workload being deployed"
  default     = "test"
  validation {
    condition = (
      can(regex("^[a-zA-Z0-9]{3,8}$", var.workload_name))
    )
    error_message = "Please enter a valid value (alphanumberic no spaces less than 8 chars)."
  }
}

variable "deployment_environment" {
  type        = string
  description = "The environment for which the deployment is being executed"
  default     = "dev"

  validation {
    condition     = contains(["dev", "uat", "prod", "dr"], var.deployment_environment)
    error_message = "Valid values for var: deployment_environment are (dev, uat, prod, dr)."
  }
}

variable "location" {
  type        = string
  description = "The location in which the deployment is happening"
  default     = "West Europe"
  validation {
    condition = anytrue([
      var.location == "West Europe",
      var.location == "North Europe"
    ])
    error_message = "Please enter a valid Azure Region."
  }
}

variable "resource_suffix" {
  type        = string
  description = ""
  default     = "001"
}

variable "apim_name" {
  type        = string
  description = ""
  default     = "apim.ipt.ch"
}

variable "app_gateway_fqdn" {
  type        = string
  description = ""
  default     = "api.ipt.ch"
}

variable "certificate_path" {
  type        = string
  description = ""
  default     = null
}

variable "certificate_password" {
  type        = string
  description = ""
  default     = null
}

variable "certificate_secret_name" {
  type        = string
  description = ""
  default     = null
}

variable "app_gateway_certificate_type" {
  type        = string
  description = "The certificate type used for the app gateway. Either custom or selfsigned"
  default     = "selfsigned"
  # To do change this to key vault or imported not self documenting
  validation {
    condition     = contains(["custom", "selfsigned"], var.app_gateway_certificate_type)
    error_message = "Valid values for var: app_gateway_certificate_type are (custom, selfsigned)."
  }
}
