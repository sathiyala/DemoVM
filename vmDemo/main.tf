#Provider
provider "azurerm" {
  features {}
}

#RG
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
    name                 = var.vnet_name
    address_space        = var.address_space
    location             = var.location
    resource_group_name  = var.rgname
    depends_on = [azurerm_resource_group.rg]
}

# Subnet for virtual machine
resource "azurerm_subnet" "vmsubnet" {
  name                  =  var.subnet_name
  address_prefix        =  var.address_prefix
  virtual_network_name  =  var.vnet_name
  resource_group_name   =  var.rgname
  depends_on = [azurerm_virtual_network.vnet]
}


# Add a Public IP address
resource "azurerm_public_ip" "vmip" {
    count                  = var.numbercount
    name                   = "vm-ip-${count.index}"
    resource_group_name    =  var.rgname
    allocation_method      = "Static"
    location               = var.location
    depends_on = [azurerm_resource_group.rg]
}

# Add a Network security group
resource "azurerm_network_security_group" "nsgname" {
    name                   = "vm-nsg"
    location               = var.location
    resource_group_name    =  var.rgname
    
   
    security_rule {
        name                       = "allow_RDP"
        description                = "Allow RDP access"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    depends_on = [azurerm_resource_group.rg]
}

#Associate NSG with  subnet
resource "azurerm_subnet_network_security_group_association" "nsgsubnet" {
    subnet_id                    = azurerm_subnet.vmsubnet.id 
    network_security_group_id    = azurerm_network_security_group.nsgname.id 
}

# NIC with Public IP Address
resource "azurerm_network_interface" "terranic" {
    count                  = var.numbercount
    name                   = "vm-nic-${count.index}"
    location               = var.location
    resource_group_name    =  var.rgname
       
    ip_configuration {
        name                          = "external"
        subnet_id                     = azurerm_subnet.vmsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = element(azurerm_public_ip.vmip.*.id, count.index)
  }
  depends_on = [azurerm_resource_group.rg]
}

#VmCreation
resource "azurerm_virtual_machine" "vm" {
    name                  = "vm${count.index}"
    location              = var.location
    resource_group_name   = var.rgname
    vm_size               = var.vm_size
    network_interface_ids = [element(azurerm_network_interface.terranic.*.id, count.index)]
    count                 = var.numbercount

    storage_image_reference {
        publisher = var.image_publisher
        offer     = var.image_offer
        sku       = var.image_sku
        version   = var.image_version
    }

    storage_os_disk {
        name          = "osdisk${count.index}"
        create_option = "FromImage"
    }

    os_profile {
        computer_name  = var.hostname
        admin_username = var.admin_username
        admin_password = var.admin_password
    }

    os_profile_windows_config {}
    }