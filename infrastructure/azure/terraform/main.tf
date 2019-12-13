provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.36.0"
}

resource "azurerm_resource_group" "openvpn-private" {
  name     = "${var.resource_group}"
  location = "${var.primary_region}"
}

resource "azurerm_virtual_network" "openvpn-vnet" {
  name                = "${var.resource_prefix}-vnet"
  location            = "${azurerm_resource_group.openvpn-private.location}"
  resource_group_name = "${azurerm_resource_group.openvpn-private.name}"
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "openvpn-subnet" {
  name                 = "openvpn-subnet"
  resource_group_name  = "${azurerm_resource_group.openvpn-private.name}"
  virtual_network_name = "${azurerm_virtual_network.openvpn-vnet.name}"
  address_prefix       = "10.0.0.0/24"
}

resource "azurerm_subnet" "openvpn-subnet-2" {
  name                 = "openvpn-subnet-2"
  resource_group_name  = "${azurerm_resource_group.openvpn-private.name}"
  virtual_network_name = "${azurerm_virtual_network.openvpn-vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_network_interface" "openvpn-nic" {
  name                = "openvpn-nic"
  location            = "${azurerm_resource_group.openvpn-private.location}"
  resource_group_name = "${azurerm_resource_group.openvpn-private.name}"

  ip_configuration {
    name                          = "openvpn_configuration"
    subnet_id                     = "${azurerm_subnet.openvpn-subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.openvpn-publicip.id}"
  }

}

resource "azurerm_public_ip" "openvpn-publicip" {
  name                = "openvpn-publicip"
  location            = "${var.primary_region}"
  resource_group_name = "${azurerm_resource_group.openvpn-private.name}"
  allocation_method   = "Dynamic"
  domain_name_label = "${var.region_dns}"
}

resource "azurerm_network_security_group" "openvpn-nsg" {
  name                = "openvpn-nsg"
  location            = "${azurerm_resource_group.openvpn-private.location}"
  resource_group_name = "${azurerm_resource_group.openvpn-private.name}"

}

resource "azurerm_network_security_rule" "openvpn-nsr-ssh" {
  name                        = "openvpn-nsr-ssh"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.openvpn-private.name}"
  network_security_group_name = "${azurerm_network_security_group.openvpn-nsg.name}"
}

resource "azurerm_network_security_rule" "openvpn-nsr-openvpn" {
  name                        = "openvpn-nsr-openvpn"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "UDP"
  source_port_range           = "*"
  destination_port_range      = "1194"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.openvpn-private.name}"
  network_security_group_name = "${azurerm_network_security_group.openvpn-nsg.name}"
}
resource "azurerm_network_security_rule" "openvpn-nsr-https" {
  name                        = "openvpn-nsr-https"
  priority                    = 1200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.openvpn-private.name}"
  network_security_group_name = "${azurerm_network_security_group.openvpn-nsg.name}"
}

resource "azurerm_storage_account" "openvpndiag" {
  name                     = "openvpndiag19029182"
  resource_group_name      = "${azurerm_resource_group.openvpn-private.name}"
  location                 = "${azurerm_resource_group.openvpn-private.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_virtual_machine" "main" {
  name                  = "${var.vm_name}"
  location              = "${azurerm_resource_group.openvpn-private.location}"
  resource_group_name   = "${azurerm_resource_group.openvpn-private.name}"
  network_interface_ids = ["${azurerm_network_interface.openvpn-nic.id}"]
  vm_size               = "${var.virtual_machine_size}" 

  plan {
    name = "netgate-pfsense-azure-243"
    publisher = "netgate"
    product = "netgate-pfsense-azure-fw-vpn-router"
  }


  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }
  storage_os_disk {
    name              = "pfsenseos-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.os_disk_type}"
  }
  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
