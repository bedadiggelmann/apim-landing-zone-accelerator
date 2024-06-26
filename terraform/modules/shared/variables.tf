#-------------------------------
# Common variables
#-------------------------------

variable "resource_suffix" {
  type = string
}

variable "location" {
  description = "The location of the apim instance"
  type        = string
}

variable "environment" {
  description = "The environment for which the deployment is being executed"
}
variable "key_vault_sku" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium"
  default     = "standard"
}

variable "bastion_host_sku" {
  description = "The SKU of the Bastion Host. Accepted values are Basic and Standard. Defaults to Basic."
  default     = "Standard"
}

variable "bastion_pip_sku" {
  description = "The SKU of the Bastion Host. Accepted values are Basic and Standard. Defaults to Basic."
  default     = "Standard"
}

variable "file_copy_enabled" {
  description = "Is File Copy feature enabled for the Bastion Host. Defaults to false."
  default     = true
}

variable "copy_paste_enabled" {
  description = "Is Copy/Paste feature enabled for the Bastion Host. Defaults to true."
  default     = true
}

variable "private_ip_address" {
  description = "Private ip address of the apim instance"
}

variable "apim_name" {
  type        = string
  description = "Resource name of the deployed internal apim instance"
}

variable "apim_vnet_id" {
  description = "APIM vnet id"
}

variable "gw_vnet_id" {
  description = "gw vnet id"
}
