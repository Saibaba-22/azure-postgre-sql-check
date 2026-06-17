resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.postgresname
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location

  administrator_login    = var.postgres-admin-user
  administrator_password = var.postgres-admin-password

  zone = "3"
  version    = "16"
  storage_mb = 32768
  sku_name   = "B_Standard_B1ms"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "myip" {
  name             = "AllowMyIP"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  
  # If you need private provide your pc and vm ip address
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}
