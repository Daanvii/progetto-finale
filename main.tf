provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "nuovo-gruppo-risorse2" {
  name     = var.resource_group_name
  location = "West Europe"
}

resource "azurerm_virtual_network" "nuova_vnet2" {
  name                = "nuova-vnet2"
  resource_group_name = azurerm_resource_group.nuovo-gruppo-risorse2.name
  location            = azurerm_resource_group.nuovo-gruppo-risorse2.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "nuova_subnet2" {
  name                 = "nuova-subnet2"
  resource_group_name  = azurerm_resource_group.nuovo-gruppo-risorse2.name
  virtual_network_name = azurerm_virtual_network.nuova_vnet2.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nuova_nsg2" {
  name                = "nuova-nsg2"
  resource_group_name = azurerm_resource_group.nuovo-gruppo-risorse2.name
  location            = "West Europe"

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowK3sNodePort"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc2" {
  subnet_id                 = azurerm_subnet.nuova_subnet2.id
  network_security_group_id = azurerm_network_security_group.nuova_nsg2.id
}

resource "azurerm_public_ip" "nuova_public_ip2" {
  name                = "nuova-public-ip2"
  resource_group_name = azurerm_resource_group.nuovo-gruppo-risorse2.name
  location            = azurerm_resource_group.nuovo-gruppo-risorse2.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nuova_nic2" {
  name                = "nuova-nic2"
  location            = azurerm_resource_group.nuovo-gruppo-risorse2.location
  resource_group_name = azurerm_resource_group.nuovo-gruppo-risorse2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.nuova_subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nuova_public_ip2.id
  }
}

resource "azurerm_linux_virtual_machine" "nuova_vm2" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.nuovo-gruppo-risorse2.name
  location            = "West Europe"
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.nuova_nic2.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.ssh_public_key_path) 
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # 🔹 Provisioner per copiare setup.sh sulla VM
  provisioner "file" {
    source      = "setup.sh"      # File locale
    destination = "/tmp/setup.sh" # Path remoto

    connection {
      type        = "ssh"
      user        = "adminuser"
      private_key = file(var.ssh_private_key_path) 
      host        = azurerm_public_ip.nuova_public_ip2.ip_address
    }
  }

  # 🔹 Provisioner per eseguire setup.sh sulla VM
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh"
    ]

    connection {
      type        = "ssh"
      user        = "adminuser"
      private_key = file(var.ssh_private_key_path) 
      host        = azurerm_public_ip.nuova_public_ip2.ip_address
    }
  }
}