
output "namespace_id" {
  value = azurerm_servicebus_namespace.sb.id
}

output "namespace_name" {
  value = azurerm_servicebus_namespace.sb.name
}

output "primary_connection_string" {
  value     = azurerm_servicebus_namespace_authorization_rule.root.primary_connection_string
  sensitive = true
}

output "queue_id" {
  value = azurerm_servicebus_queue.q.id
}
