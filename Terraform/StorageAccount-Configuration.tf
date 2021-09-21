resource "random_integer" "storageaccountconfigsuffix" {
  min = 1000000
  max = 9999999

  keepers = {
    # Generate a new integer when the resource group changes.
    rg = "${azurerm_resource_group.storage.name}"
  }
}

resource "azurerm_storage_account" "configuration" {
  name                      = "sa${var.org_abb}${var.reg_abb}${var.env_abb}config${random_integer.storageaccountconfigsuffix.result}"
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = azurerm_resource_group.storage.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = true
  is_hns_enabled            = false
  nfsv3_enabled             = false
  shared_access_key_enabled = true
  account_replication_type  = "ZRS"
  tags                      = var.tags

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.sa_config_ip_rules
    virtual_network_subnet_ids = [azurerm_subnet.main.id]

    private_link_access {
      endpoint_resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_resource_group.app.name}/providers/Microsoft.Logic/workflows/*"
    }
  }
}

# NOTE: Creating a container using Terraform 'azurerm_storage_container' was raising an 'Authorization Failure' exception.
# The issue is documented here: https://github.com/hashicorp/terraform-provider-azurerm/issues/2977
# Workaround using an ARM template.
resource "azurerm_template_deployment" "storagecontainerblobconfiguration" {
  depends_on          = [azurerm_storage_account.configuration]
  name                = "${azurerm_storage_account.configuration.name}-container-blob-default"
  resource_group_name = azurerm_resource_group.storage.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/ArmTemplates/StorageAccountContainer.json")
  parameters = {
    storage_account_name = azurerm_storage_account.configuration.name
    container_name       = "default"
  }
}

resource "azurerm_storage_blob" "configlogicappssendgridtemplateinbound" {
  name                   = "config.logicapps.sendgridtemplate.inbound.json"
  storage_account_name   = azurerm_storage_account.configuration.name
  storage_container_name = "default"
  type                   = "Block"
  content_type           = "application/json"
  source                 = "${path.module}/Configuration/LogicApp-Inbound-SendGridTemplate.json"
  depends_on = [
    azurerm_template_deployment.storagecontainerblobconfiguration
  ]
}

resource "azurerm_storage_blob" "configlogicappssendgridtemplateoutbound" {
  name                   = "config.logicapps.sendgridtemplate.outbound.json"
  storage_account_name   = azurerm_storage_account.configuration.name
  storage_container_name = "default"
  type                   = "Block"
  content_type           = "application/json"
  source                 = "${path.module}/Configuration/LogicApp-Outbound-SendGridTemplate.json"
  depends_on = [
    azurerm_template_deployment.storagecontainerblobconfiguration
  ]
}

resource "azurerm_storage_blob" "configsendgridschema" {
  name                   = "config.logicapps.sendgridtemplate.schema.json"
  storage_account_name   = azurerm_storage_account.configuration.name
  storage_container_name = "default"
  type                   = "Block"
  content_type           = "application/json"
  source                 = "${path.module}/Configuration/SendGridTemplateSchema.json"
  depends_on = [
    azurerm_template_deployment.storagecontainerblobconfiguration
  ]
}

resource "azurerm_role_assignment" "lainboundtosaconfiguration" {
  scope              = azurerm_storage_account.configuration.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.storageblobreader.id}"
  principal_id       = azurerm_template_deployment.logicappinbound.outputs["principalId"]
}

resource "azurerm_role_assignment" "laoutboundtosaconfiguration" {
  scope              = azurerm_storage_account.configuration.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.storageblobreader.id}"
  principal_id       = azurerm_template_deployment.logicappoutbound.outputs["principalId"]
}
