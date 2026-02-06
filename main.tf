terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Use this for version 3.x
  skip_provider_registration = true
}

# 1. The Resource Group
resource "azurerm_resource_group" "project_rg" {
  name     = "rg-3tier-webstack"
  location = "East US"
}

# 2. The Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-3tier"
  location            = azurerm_resource_group.project_rg.location
  resource_group_name = azurerm_resource_group.project_rg.name
  address_space       = var.vnet_address_space
}

# 3. The Subnets (The "Tiers")
resource "azurerm_subnet" "frontend" {
  name                 = "snet-frontend"
  resource_group_name  = azurerm_resource_group.project_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_frontend_prefix
}

resource "azurerm_subnet" "backend" {
  name                 = "snet-backend"
  resource_group_name  = azurerm_resource_group.project_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_backend_prefix
}

resource "azurerm_subnet" "database" {
  name                 = "snet-database"
  resource_group_name  = azurerm_resource_group.project_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_database_prefix
}

resource "azurerm_subnet" "management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.project_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_management_prefix
}

# Network Security Group for the Backend
resource "azurerm_network_security_group" "nsg_backend" {
  name                = "nsg-backend"
  location            = azurerm_resource_group.project_rg.location
  resource_group_name = azurerm_resource_group.project_rg.name

  # Rules Here
}

resource "azurerm_subnet_network_security_group_association" "backend_assoc" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.nsg_backend.id
}

# Network Security Group for the Database
resource "azurerm_network_security_group" "nsg_database" {
  name                = "nsg-database"
  location            = azurerm_resource_group.project_rg.location
  resource_group_name = azurerm_resource_group.project_rg.name
  security_rule {
    name                   = "AllowBackendInbound"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "3306"
    # This pulls the Backend IP range automatically from your variables!
    source_address_prefix      = var.subnet_backend_prefix[0]
    destination_address_prefix = var.subnet_database_prefix[0]
  }
}

#NSG Association for Database
resource "azurerm_subnet_network_security_group_association" "db_assoc" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.nsg_database.id
}

resource "azurerm_network_security_group" "nsg_frontend" {
  name                = "nsg-frontend"
  location            = azurerm_resource_group.project_rg.location
  resource_group_name = azurerm_resource_group.project_rg.name
}

resource "azurerm_subnet_network_security_group_association" "frontend_assoc" {
  subnet_id                 = azurerm_subnet.frontend.id
  network_security_group_id = azurerm_network_security_group.nsg_frontend.id
}

resource "azurerm_network_security_group" "nsg_management" {
  name                = "nsg-management"
  location            = azurerm_resource_group.project_rg.location
  resource_group_name = azurerm_resource_group.project_rg.name
}

resource "azurerm_subnet_network_security_group_association" "mgmt_assoc" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.nsg_management.id
}