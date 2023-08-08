locals {
  apim_cs_vnet_name      = "vnet-apim-cs-${var.resource_suffix}"
  apim_gw_vnet_name      = "vnet-apim-gw-${var.resource_suffix}"
  apim_subnet_name       = "snet-apim-${var.resource_suffix}"
  apim_snnsg             = "nsg-apim-${var.resource_suffix}"
  appgateway_subnet_name = "snet-apgw-${var.resource_suffix}"
  appgateway_snnsg       = "nsg-apgw-${var.resource_suffix}"
  public_ip_address_name = "pip-apimcs-${var.resource_suffix}"
}

resource "azurerm_resource_group" "networking_resource_group" {
  name     = "rg-networking-${var.resource_suffix}"
  location = var.location
  tags = {
    "expireOn" = "2023-08-30"
  }
}

//Vnet
resource "azurerm_virtual_network" "apim_cs_vnet" {
  name                = local.apim_cs_vnet_name
  location            = azurerm_resource_group.networking_resource_group.location
  resource_group_name = azurerm_resource_group.networking_resource_group.name
  address_space       = [var.apim_cs_vnet_name_address_prefix]

  subnet {
    name           = local.apim_subnet_name
    address_prefix = var.apim_subnet_address_prefix
    security_group = azurerm_network_security_group.apim_snnsg_nsg.id
  }

}

resource "azurerm_virtual_network" "apim_gw_vnet" {
  name                = local.apim_gw_vnet_name
  location            = azurerm_resource_group.networking_resource_group.location
  resource_group_name = azurerm_resource_group.networking_resource_group.name
  address_space       = [var.apim_gw_vnet_name_address_prefix]

  subnet {
    name           = local.appgateway_subnet_name
    address_prefix = var.appgateway_subnet_address_prefix
    security_group = azurerm_network_security_group.appgateway_nsg.id

  }

}


//App Gateway NSG
resource "azurerm_network_security_group" "appgateway_nsg" {
  name                = local.appgateway_snnsg
  location            = azurerm_resource_group.networking_resource_group.location
  resource_group_name = azurerm_resource_group.networking_resource_group.name

  security_rule {
    name                       = "AllowHealthProbesInbound"
    priority                   = 100
    protocol                   = "*"
    destination_port_range     = "65200-65535"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowTLSInbound"
    priority                   = 110
    protocol                   = "Tcp"
    destination_port_range     = "443"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 111
    protocol                   = "Tcp"
    destination_port_range     = "80"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 121
    protocol                   = "Tcp"
    destination_port_range     = "*"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
}

//APIM SNNSG NSG
resource "azurerm_network_security_group" "apim_snnsg_nsg" {
  name                = local.apim_snnsg
  location            = azurerm_resource_group.networking_resource_group.location
  resource_group_name = azurerm_resource_group.networking_resource_group.name

  security_rule {
    name                       = "AllowApimVnetInbound"
    priority                   = 2000
    protocol                   = "Tcp"
    destination_port_range     = "3443"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "apim-azure-infra-lb"
    priority                   = 2010
    protocol                   = "Tcp"
    destination_port_range     = "6390"
    access                     = "Allow"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "apim-azure-storage"
    priority                   = 2000
    protocol                   = "Tcp"
    destination_port_range     = "443"
    access                     = "Allow"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  }

  security_rule {
    name                       = "apim-azure-sql"
    priority                   = 2010
    protocol                   = "Tcp"
    destination_port_range     = "1443"
    access                     = "Allow"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "SQL"
  }

  security_rule {
    name                       = "apim-azure-kv"
    priority                   = 2020
    protocol                   = "Tcp"
    destination_port_range     = "443"
    access                     = "Allow"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureKeyVault"
  }

}

resource "azurerm_virtual_network_peering" "peer_gw_apim" {
  name                         = "peer-vnet-gw-with-apim"
  resource_group_name          = azurerm_resource_group.networking_resource_group.name
  virtual_network_name         = azurerm_virtual_network.apim_cs_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.apim_gw_vnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peer_apim_gw" {
  name                         = "peer-vnet-apim-with-gw"
  resource_group_name          = azurerm_resource_group.networking_resource_group.name
  virtual_network_name         = azurerm_virtual_network.apim_gw_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.apim_cs_vnet.id
  allow_virtual_network_access = true
}


//Public IP
resource "azurerm_public_ip" "apim_public_ip" {
  name                = local.public_ip_address_name
  resource_group_name = azurerm_resource_group.networking_resource_group.name
  location            = azurerm_resource_group.networking_resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
