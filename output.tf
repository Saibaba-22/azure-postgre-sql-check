# SQL ENDPOINT
output "postgres_server_name" {
  value = azurerm_postgresql_flexible_server.postgres.name
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.database.name
}

# DB Name
output "administrator_login" {
  value = azurerm_postgresql_flexible_server_database.database.name
}

# Dotnet App link 
output "vm_public_ip" {
  value = "http://${azurerm_linux_virtual_machine.vm1.public_ip_addresses[0]}:8080"
}

