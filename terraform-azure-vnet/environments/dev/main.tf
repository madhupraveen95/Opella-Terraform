provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "TF-Dev-RG" {
  name     = "dev-eastus"
  location = "eastus"
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-dev-eastus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnets = {
    "subnet1" = ["10.0.1.0/24"]
    "subnet2" = ["10.0.2.0/24"]
  }
  tags = {
    environment = "dev"
    region      = "eastus"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = tf-devstorage
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_interface" "nic" {
  name                = "dev-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["subnet1"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "dev-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "OpellaAdmin"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  admin_password = "Opell@123!"
}
