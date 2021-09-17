resource "azurerm_template_deployment" "logicappinbound" {
  depends_on          = [azurerm_storage_account.inbound]
  name                = "la-${var.org_abb}-${var.reg_abb}-${var.env_abb}-inbound"
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/ArmTemplates/LogicApp-Inbound.json")
  parameters = {
    LogicAppName                    = "la-${var.org_abb}-${var.reg_abb}-${var.env_abb}-inbound"
    LogicAppLocation                = azurerm_resource_group.app.location
    StorageAccountInboundName       = azurerm_storage_account.inbound.name
    StorageAccountConfigurationName = azurerm_storage_account.configuration.name
    AllowedCallerIpAddresses        = "${azurerm_public_ip.pip.ip_address}/32" # Can be specified in range 'xxx.xxx.xxx.xxx-xxx.xxx.xxx.xxx' or CIDR 'xxx.xxx.xxx.xxx/xx' format.
    KeyVaultName                    = azurerm_key_vault.main.name
    SendGridApiSecretName           = azurerm_key_vault_secret.sendgrid_api_key.name
  }
}

# Get a reference to the logic app - inbound
data "azurerm_resources" "logicappinbound" {
  type = "Microsoft.Logic/workflows"
  name = azurerm_template_deployment.logicappinbound.name
}
