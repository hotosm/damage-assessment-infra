resource "random_integer" "storageaccountoutboundsuffix" {
  min = 10000
  max = 99999

  keepers = {
    # Generate a new integer when the resource group changes.
    rg = "${azurerm_resource_group.storage.name}"
  }
}

resource "azurerm_storage_account" "outbound" {
  name                      = "sa${var.org_abb}${var.reg_abb}${var.env_abb}outbound${random_integer.storageaccountoutboundsuffix.result}"
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = azurerm_resource_group.storage.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = true
  is_hns_enabled            = true
  nfsv3_enabled             = true
  shared_access_key_enabled = true
  account_replication_type  = "LRS"
  tags                      = var.tags

  routing {
    choice = "MicrosoftRouting"
  }

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.sa_outbound_ip_rules
    virtual_network_subnet_ids = [azurerm_subnet.main.id]

    private_link_access {
      endpoint_resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_resource_group.app.name}/providers/Microsoft.Logic/workflows/*"
    }
  }
}

# NOTE: Creating a container using Terraform 'azurerm_storage_container' was raising an 'Authorization Failure' exception.
# The issue is documented here: https://github.com/hashicorp/terraform-provider-azurerm/issues/2977
# Workaround using an ARM template.
resource "azurerm_template_deployment" "storagecontainerbloboutbound" {
  depends_on          = [azurerm_storage_account.outbound]
  name                = "${azurerm_storage_account.outbound.name}-container-blob-default"
  resource_group_name = azurerm_resource_group.storage.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/ArmTemplates/StorageAccountContainer.json")
  parameters = {
    storage_account_name = azurerm_storage_account.outbound.name
    container_name       = "default"
  }
}

resource "azurerm_role_assignment" "laoutboundtosaoutbound" {
  scope              = azurerm_storage_account.outbound.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.storageblobcontributor.id}"
  principal_id       = azurerm_template_deployment.logicappoutbound.outputs["principalId"]
}

resource "azurerm_storage_management_policy" "outbound" {
  storage_account_id = azurerm_storage_account.outbound.id

  rule {
    name    = "OutboundPolicy"
    enabled = true
    filters {
      prefix_match = ["default"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }
    }
  }
}
