
# Use existing RG
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_servicebus_namespace" "sb" {
  name                = var.namespace_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku                 = var.sku
  capacity            = var.capacity
  zone_redundant      = var.zone_redundant
  minimum_tls_version = var.minimum_tls_version

  public_network_access_enabled = var.public_network_access_enabled
  local_authentication_enabled  = var.local_authentication_enabled

  identity { type = "SystemAssigned" }

  tags = var.tags

  network_rule_set {
    default_action = "Allow"
    # Note: add ip_rules and subnet_rules here if needed
  }
}

resource "azurerm_servicebus_namespace_authorization_rule" "root" {
  name         = "RootManageSharedAccessKey"
  namespace_id = azurerm_servicebus_namespace.sb.id
  listen       = true
  send         = true
  manage       = true
}

resource "azurerm_servicebus_queue" "q" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.sb.id

  max_message_size_in_kilobytes         = var.queue_max_message_size_kb
  lock_duration                         = var.queue_lock_duration
  max_size_in_megabytes                 = var.queue_max_size_mb
  requires_duplicate_detection          = var.queue_requires_duplicate_detection
  requires_session                      = var.queue_requires_session
  default_message_ttl                   = var.queue_default_ttl
  dead_lettering_on_message_expiration  = var.queue_dead_lettering_on_message_expiration
  enable_batched_operations             = var.queue_enable_batched_operations
  duplicate_detection_history_time_window = var.queue_duplicate_detection_history_window
  max_delivery_count                    = var.queue_max_delivery_count
  status                                = var.queue_status
  auto_delete_on_idle                   = var.queue_auto_delete_on_idle
  enable_partitioning                   = var.queue_enable_partitioning
  enable_express                        = var.queue_enable_express
}

# Optional: create a Private Endpoint to the Service Bus namespace
resource "azurerm_private_endpoint" "sb" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "${var.namespace_name}-pe"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  subnet_id = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.namespace_name}-pe-conn"
    private_connection_resource_id = azurerm_servicebus_namespace.sb.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }

  # Attach DNS zone to the PE
  private_dns_zone_group {
    name                 = "${var.namespace_name}-pdzg"
    private_dns_zone_ids = var.private_dns_zone_rg_name == null ? [] : [
      data.azurerm_private_dns_zone.sb.id
    ]
  }
}

# Private DNS zone (data) and VNet link
data "azurerm_private_dns_zone" "sb" {
  count               = var.private_dns_zone_rg_name == null ? 0 : 1
  name                = var.private_dns_zone_name
  resource_group_name = var.private_dns_zone_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sb" {
  count                 = var.virtual_network_id == null ? 0 : 1
  name                  = var.dns_link_name
  resource_group_name   = var.private_dns_zone_rg_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = var.dns_registration_enabled
}
