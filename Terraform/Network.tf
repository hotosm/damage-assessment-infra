
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_subnet" "main" {
  name                                           = "vnet-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01-subnet-01"
  resource_group_name                            = azurerm_resource_group.network.name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = ["10.0.0.0/24"]
  service_endpoints                              = ["Microsoft.Storage", "Microsoft.KeyVault"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_public_ip" "pip" {
  name                = "vm-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01-pip"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm" {
  name                = "vm-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01-nic-external"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_security_group" "subnet" {
  name                = "vm-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01-nsg"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.subnet.id
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "nsgsr-${var.org_abb}-${var.reg_abb}-${var.env_abb}-ssh"
  priority                    = 100
  access                      = "Allow"
  direction                   = "Inbound"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.nsg_allowed_addresses_ssh
  destination_address_prefix  = azurerm_network_interface.vm.private_ip_address
  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.subnet.name
}

resource "azurerm_network_security_rule" "https" {
  name                        = "nsgsr-${var.org_abb}-${var.reg_abb}-${var.env_abb}-https"
  priority                    = 200
  access                      = "Allow"
  direction                   = "Inbound"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = var.nsg_allowed_addresses_https
  destination_address_prefix  = azurerm_network_interface.vm.private_ip_address
  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.subnet.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "nsgsr-${var.org_abb}-${var.reg_abb}-${var.env_abb}-http"
  priority                    = 300
  access                      = "Allow"
  direction                   = "Inbound"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = var.nsg_allowed_addresses_http
  destination_address_prefix  = azurerm_network_interface.vm.private_ip_address
  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.subnet.name
}
