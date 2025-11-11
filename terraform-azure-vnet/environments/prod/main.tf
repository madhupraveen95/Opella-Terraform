provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "TF-Prod-rg" {
  name     = "rg-prod-eastus"
  location = "eastus"
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-prod-eastus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
  subnets = {
    "subnet1" = ["10.1.1.0/24"]
    "subnet2" = ["10.1.2.0/24"]
  }
  tags = {
    environment = "prod"
    region      = "eastus"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "prodstorage${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_interface" "nic" {
  name                = "prod-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["subnet1"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "prod-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "produser"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  admin_password = "Opell@2025!"
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}
