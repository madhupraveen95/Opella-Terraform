output "vnet_id" {
  description = "vnet id"
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "subnet ids"
  value       = { for s, v in azurerm_subnet.subnets : s => v.id }
}
