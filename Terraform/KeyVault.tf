resource "random_string" "keyvaultsuffix" {
  length  = 6
  lower   = true
  upper   = true
  number  = true
  special = false

  keepers = {
    # Generate a new integer when the resource group changes.
    rg = "${azurerm_resource_group.secrets.name}"
  }
}

resource "azurerm_key_vault" "main" {
  name                            = "kv-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01-${random_string.keyvaultsuffix.result}"
  location                        = azurerm_resource_group.secrets.location
  resource_group_name             = azurerm_resource_group.secrets.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  sku_name                        = "standard"
  soft_delete_retention_days      = 7
  tags                            = var.tags

  # NOTE: Azure Logic Apps (consumption) are not able to join the VNet (unless in an ISE). Security controlled by Azure RBAC.
  # network_acls {
  #   bypass                     = "AzureServices"
  #   default_action             = "Deny"
  #   ip_rules                   = var.keyvault_allowed_addresses
  #   virtual_network_subnet_ids = [azurerm_subnet.main.id]
  # }
}

# ------------------------------------------------------------------------------
# Secrets
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "sendgrid_api_key" {
  name         = "${azurerm_key_vault.main.name}-sendgrid-api-key"
  value        = var.hot_sendgrid_api_key
  key_vault_id = azurerm_key_vault.main.id

  # Required to allow Terraform to check if the secret already exists.
  depends_on = [
    azurerm_role_assignment.terraformprincipalkeyvault
  ]
}

# ------------------------------------------------------------------------------
# Role Assignments
# ------------------------------------------------------------------------------
# Required for Terraform deployment principal (grants permission to check a key vault for an existing secret).
resource "azurerm_role_assignment" "terraformprincipalkeyvault" {
  scope              = azurerm_key_vault.main.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.keyvaultsecretsadministrator.id}"
  principal_id       = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "lainboundtokeyvault" {
  scope              = azurerm_key_vault.main.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.keyvaultsecretsuser.id}"
  principal_id       = azurerm_template_deployment.logicappinbound.outputs["principalId"]
}

resource "azurerm_role_assignment" "laoutboundtokeyvault" {
  scope              = azurerm_key_vault.main.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.keyvaultsecretsuser.id}"
  principal_id       = azurerm_template_deployment.logicappoutbound.outputs["principalId"]
}
