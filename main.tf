resource "azurerm_resource_group" "rg" {
    name = "rg-jenkins-security-gate"
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name = "vnet-jenkins-security-gate"
    address_space = ["10.10.0.0/16"]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
    name = "subnet-jenkins"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.10.1.0/24"]
}