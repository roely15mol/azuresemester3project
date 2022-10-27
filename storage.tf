resource "azurerm_storage_account" "vmss" {
  name                     = "semester3test"
  resource_group_name      = azurerm_resource_group.vmss.name
  location                 = azurerm_resource_group.vmss.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_share" "vmss" {
  name                 = "sharename"
  storage_account_name = azurerm_storage_account.vmss.name
  quota                = 50

}
