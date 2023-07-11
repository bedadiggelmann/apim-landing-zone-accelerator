locals {
  resource_location = lower(replace(var.location, " ", ""))
}

#-------------------------------
# calling the Resource Naming module
#-------------------------------
module "resource_suffix" {
  source                 = "./modules/service-suffix"
  workload_name          = var.workload_name
  deployment_environment = var.deployment_environment
  location               = local.resource_location
  resource_suffix        = var.resource_suffix
}

#-------------------------------
# calling the Shared module
#-------------------------------
module "shared" {
  source             = "./modules/shared"
  resource_suffix    = module.resource_suffix.name
  location           = local.resource_location
  environment        = var.deployment_environment
  private_ip_address = module.apim.private_ip_addresses
  apim_name          = module.apim.name
  apim_vnet_id       = module.networking.apim_cs_vnet_id
  gw_vnet_id         = module.networking.apim_gw_vnet_id
}

#-------------------------------
# calling the APIM module
#-------------------------------
module "apim" {
  source            = "./modules/apim"
  resource_suffix   = module.resource_suffix.name
  location          = local.resource_location
  apim_subnet_id    = module.networking.apim_subnet_id
  apim_public_ip_id = module.networking.public_ip
}


#-------------------------------
# calling the networking module
#-------------------------------
module "networking" {
  source                 = "./modules/networking"
  location               = local.resource_location
  workload_name          = var.workload_name
  deployment_environment = var.deployment_environment
  resource_suffix        = module.resource_suffix.name

}

#-------------------------------
# calling the App Gateway module
#-------------------------------
module "application_gateway" {
  source                       = "./modules/gateway"
  resource_suffix              = module.resource_suffix.name
  location                     = module.apim.apim_resource_group_location
  secret_name                  = var.certificate_secret_name
  keyvault_id                  = module.shared.key_vault_id
  app_gateway_certificate_type = var.app_gateway_certificate_type
  certificate_path             = var.certificate_path
  certificate_password         = var.certificate_password
  fqdn                         = var.app_gateway_fqdn
  primary_backend_fqdn         = "${module.apim.name}.azure-api.net"
  subnet_id                    = module.networking.appgateway_subnet_id
  depends_on                   = [
    module.shared
  ]
}
