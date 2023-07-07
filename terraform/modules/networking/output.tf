output "public_ip" {
  value = azurerm_public_ip.apim_public_ip.id
}

output "apim_cs_vnet_id" {
  value = azurerm_virtual_network.apim_cs_vnet.id
}

output "apim_subnet_id" {
  value = "${azurerm_virtual_network.apim_cs_vnet.id}/subnets/${local.apim_subnet_name}"
}

output "appgateway_subnet_id" {
  value = "${azurerm_virtual_network.apim_cs_vnet.id}/subnets/${local.appgateway_subnet_name}"
}

