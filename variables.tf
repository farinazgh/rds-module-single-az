
variable "resource_group_name" { type = string }
variable "location"            { type = string  default = "northeurope" }
variable "namespace_name"      { type = string  default = "neptun" }

variable "sku"                 { type = string  default = "Premium" }
variable "capacity"            { type = number  default = 1 }
variable "zone_redundant"      { type = bool    default = true }
variable "minimum_tls_version" { type = string  default = "1.2" }
variable "public_network_access_enabled" { type = bool default = false }
variable "local_authentication_enabled"  { type = bool default = true }

variable "tags" {
  type = map(string)
  default = {
    Application    = "gitlab-runner"
    BusinessUnit   = "IT-Functional"
    Environment    = "test"
    KPE            = "business critical - criticality 4"
    SecurityPolicy = "Normal"
    TechnicalOwner = "owner@example.com"
  }
}

# Queue settings from ARM export
variable "queue_name"                               { type = string default = "testqueue" }
variable "queue_max_message_size_kb"                { type = number default = 1024 }
variable "queue_lock_duration"                      { type = string default = "PT1M" }
variable "queue_max_size_mb"                        { type = number default = 1024 }
variable "queue_requires_duplicate_detection"       { type = bool   default = true }
variable "queue_requires_session"                   { type = bool   default = false }
variable "queue_default_ttl"                        { type = string default = "P14D" }
variable "queue_dead_lettering_on_message_expiration" { type = bool default = true }
variable "queue_enable_batched_operations"          { type = bool   default = true }
variable "queue_duplicate_detection_history_window" { type = string default = "P1DT10M" }
variable "queue_max_delivery_count"                 { type = number default = 10 }
variable "queue_status"                             { type = string default = "Active" }
variable "queue_auto_delete_on_idle"                { type = string default = "P10675199DT2H48M5.4775807S" }
variable "queue_enable_partitioning"                { type = bool   default = false }
variable "queue_enable_express"                     { type = bool   default = false }

# Optional private endpoint creation (off by default since ARM referenced an existing one)
variable "create_private_endpoint" { type = bool default = false }
variable "private_endpoint_subnet_id" { type = string default = null }

# Private DNS zone link to VNet (from separate ARM snippet)
variable "private_dns_zone_name"      { type = string default = "privatelink.servicebus.windows.net" }
variable "private_dns_zone_rg_name"   { type = string default = null }
variable "dns_link_name"              { type = string default = "vtxigw5wpemue" }
variable "virtual_network_id"         { type = string default = null }
variable "dns_registration_enabled"   { type = bool   default = false }
