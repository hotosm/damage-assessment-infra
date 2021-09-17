resource "azurerm_template_deployment" "logicappoutbound" {
  depends_on          = [azurerm_storage_account.outbound]
  name                = "la-${var.org_abb}-${var.reg_abb}-${var.env_abb}-outbound"
  resource_group_name = azurerm_resource_group.app.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/ArmTemplates/LogicApp-Outbound.json")
  parameters = {
    LogicAppName                    = "la-${var.org_abb}-${var.reg_abb}-${var.env_abb}-outbound"
    VmName                          = "vm-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01" #azurerm_linux_virtual_machine.app.name # Hardcoded to prevent Terraform circular reference.
    StorageAccountConfigurationName = azurerm_storage_account.configuration.name
    BackupScriptPathFileName        = "/root/scripts/db_backup.sh"
    BackupRootDirectory             = "/mnt/storageoutbound"
    AllowedCallerIpAddresses        = "${azurerm_public_ip.pip.ip_address}/32" # Can be specified in range 'xxx.xxx.xxx.xxx-xxx.xxx.xxx.xxx' or CIDR 'xxx.xxx.xxx.xxx/xx' format.
    KeyVaultName                    = azurerm_key_vault.main.name
    SendGridApiSecretName           = azurerm_key_vault_secret.sendgrid_api_key.name
  }
}

# Get a reference to the logic app - outbound
data "azurerm_resources" "logicappoutbound" {
  type = "Microsoft.Logic/workflows"
  name = azurerm_template_deployment.logicappoutbound.name
}
