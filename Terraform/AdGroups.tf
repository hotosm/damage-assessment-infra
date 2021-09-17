#resource "azuread_user" "group_owner" {
#  user_principal_name = "example-group-owner@hashicorp.com"
#  display_name        = "Group Owner"
#  mail_nickname       = "example-group-owner"
#  password            = "SecretP@sswd99!"
#}

# ------------------------------------------------------------------------------
# Application Resource Group
# ------------------------------------------------------------------------------
resource "azuread_group" "rg_app_owners" {
  display_name     = "AZGRP_RG_App_Owners"
  security_enabled = true

#  owners = [
#    data.azuread_client_config.current.object_id
#  ]
}

resource "azurerm_role_assignment" "app_owners" {
  scope              = azurerm_resource_group.app.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.rg_app_owners.object_id
}

resource "azuread_group" "rg_app_contributors" {
  display_name     = "AZGRP_RG_App_Contributors"
  security_enabled = true
}

resource "azurerm_role_assignment" "app_contributors" {
  scope              = azurerm_resource_group.app.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.rg_app_contributors.object_id
}

resource "azuread_group" "rg_app_readers" {
  display_name     = "AZGRP_RG_App_Readers"
  security_enabled = true
}

resource "azurerm_role_assignment" "app_readers" {
  scope              = azurerm_resource_group.app.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.rg_app_readers.object_id
}

# ------------------------------------------------------------------------------
# Secrets Resource Group (Key Vault)
# ------------------------------------------------------------------------------
resource "azuread_group" "rg_secrets_owners" {
  display_name     = "AZGRP_RG_Secrets_Owners"
  security_enabled = true
}

resource "azurerm_role_assignment" "secrets_owners" {
  scope              = azurerm_resource_group.secrets.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.rg_secrets_owners.object_id
}

resource "azuread_group" "rg_secrets_contributors" {
  display_name     = "AZGRP_RG_Secrets_Contributors"
  security_enabled = true
}

resource "azurerm_role_assignment" "secrets_contributors" {
  scope              = azurerm_resource_group.secrets.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.rg_secrets_contributors.object_id
}

resource "azuread_group" "rg_secrets_readers" {
  display_name     = "AZGRP_RG_Secrets_Readers"
  security_enabled = true
}

resource "azurerm_role_assignment" "secrets_readers" {
  scope              = azurerm_resource_group.secrets.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.rg_secrets_readers.object_id
}

# ------------------------------------------------------------------------------
# Storage Resource Group
# ------------------------------------------------------------------------------
resource "azuread_group" "rg_storage_owners" {
  display_name     = "AZGRP_RG_Storage_Owners"
  security_enabled = true
}

resource "azurerm_role_assignment" "storage_owners" {
  scope              = azurerm_resource_group.storage.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.rg_storage_owners.object_id
}

resource "azuread_group" "rg_storage_contributors" {
  display_name     = "AZGRP_RG_Storage_Contributors"
  security_enabled = true
}

resource "azurerm_role_assignment" "storage_contributors" {
  scope              = azurerm_resource_group.storage.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.rg_storage_contributors.object_id
}

resource "azuread_group" "rg_storage_readers" {
  display_name     = "AZGRP_RG_Storage_Readers"
  security_enabled = true
}

resource "azurerm_role_assignment" "storage_readers" {
  scope              = azurerm_resource_group.storage.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.rg_storage_readers.object_id
}

# ------------------------------------------------------------------------------
# Network Resource Group
# ------------------------------------------------------------------------------
resource "azuread_group" "rg_network_owners" {
  display_name     = "AZGRP_RG_Network_Owners"
  security_enabled = true
}

resource "azurerm_role_assignment" "network_owners" {
  scope              = azurerm_resource_group.network.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.rg_network_owners.object_id
}

resource "azuread_group" "rg_network_contributors" {
  display_name     = "AZGRP_RG_Network_Contributors"
  security_enabled = true
}

resource "azurerm_role_assignment" "network_contributors" {
  scope              = azurerm_resource_group.network.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.rg_network_contributors.object_id
}

resource "azuread_group" "rg_network_readers" {
  display_name     = "AZGRP_RG_Network_Readers"
  security_enabled = true
}

resource "azurerm_role_assignment" "network_readers" {
  scope              = azurerm_resource_group.network.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.rg_network_readers.object_id
}

# ------------------------------------------------------------------------------
# Maintenance (LogAnalytics and SharedServices Resource Groups)
# ------------------------------------------------------------------------------
resource "azuread_group" "maintenance_owners" {
  display_name     = "AZGRP_Maintenance_Owners"
  security_enabled = true
}

resource "azurerm_role_assignment" "maintenance_loganalytics_owners" {
  scope              = azurerm_resource_group.loganalytics.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.maintenance_owners.object_id
}

resource "azurerm_role_assignment" "maintenance_sharedservices_owners" {
  scope              = azurerm_resource_group.sharedservices.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.maintenance_owners.object_id
}

resource "azuread_group" "maintenance_contributors" {
  display_name     = "AZGRP_Maintenance_Contributors"
  security_enabled = true
}

resource "azurerm_role_assignment" "maintenance_loganalytics_contributors" {
  scope              = azurerm_resource_group.loganalytics.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.maintenance_contributors.object_id
}

resource "azurerm_role_assignment" "maintenance_sharedservices_contributors" {
  scope              = azurerm_resource_group.sharedservices.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.maintenance_contributors.object_id
}

resource "azuread_group" "maintenance_readers" {
  display_name     = "AZGRP_Maintenance_Readers"
  security_enabled = true
}

resource "azurerm_role_assignment" "maintenance_loganalytics_readers" {
  scope              = azurerm_resource_group.loganalytics.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.maintenance_readers.object_id
}

resource "azurerm_role_assignment" "maintenance_sharedservices_readers" {
  scope              = azurerm_resource_group.sharedservices.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.maintenance_readers.object_id
}
