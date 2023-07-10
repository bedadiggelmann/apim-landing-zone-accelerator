#data "azurerm_api_management" "apim" {
#  resource_group_name = module.apim.apim_resource_group_name
#  name                = module.apim.name
#}
#
#output "api_management_id" {
#  value = data.azurerm_api_management.apim.id
#}
#
#output "api_management_name" {
#  value = data.azurerm_api_management.apim.name
#}
#
#output "apim_resource_group_name" {
#  value = data.azurerm_api_management.apim.resource_group_name
#}
#
#output "api_management_location" {
#  value = data.azurerm_api_management.apim.location
#}
