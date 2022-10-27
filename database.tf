resource "azurerm_mysql_server" "wordpress" {
  name                = "wordpress-mysqlserver-semester3-test2"
  location            = azurerm_resource_group.vmss.location
  resource_group_name = azurerm_resource_group.vmss.name
  tags                = var.tags

  administrator_login          = var.mysql_admin_user
  administrator_login_password = var.mysql_admin_password
  sku_name                     = "B_Gen5_1" # cheapest
  storage_mb                   = 5120       # smallest
  version                      = "5.7"

  auto_grow_enabled                = true
  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  public_network_access_enabled    = true                     # for demo
  ssl_enforcement_enabled          = false                    # TODO
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled" # "TLS1_2"
}

resource "azurerm_mysql_database" "wordpress" {
  name                = "wordpress-db"
  resource_group_name = azurerm_resource_group.vmss.name
  server_name         = azurerm_mysql_server.wordpress.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "azure" {
  name                = "public-internet"
  resource_group_name = azurerm_resource_group.vmss.name
  server_name         = azurerm_mysql_server.wordpress.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}