resource "random_integer" "storageaccountbackupsuffix" {
  min = 1000000
  max = 9999999

  keepers = {
    # Generate a new integer when the resource group changes.
    rg = "${azurerm_resource_group.storage.name}"
  }
}

resource "azurerm_storage_account" "backup" {
  name                      = "sa${var.org_abb}${var.reg_abb}${var.env_abb}backup${random_integer.storageaccountbackupsuffix.result}"
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = azurerm_resource_group.storage.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  access_tier               = "Cool"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
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
    ip_rules                   = var.sa_inbound_ip_rules
    virtual_network_subnet_ids = [azurerm_subnet.main.id]
  }
}

# NOTE: Creating a container using Terraform 'azurerm_storage_container' was raising an 'Authorization Failure' exception.
# The issue is documented here: https://github.com/hashicorp/terraform-provider-azurerm/issues/2977
# Workaround using an ARM template.
resource "azurerm_template_deployment" "storagecontainerblobbackup" {
  depends_on          = [azurerm_storage_account.backup]
  name                = "${azurerm_storage_account.backup.name}-container-blob-default"
  resource_group_name = azurerm_resource_group.storage.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/ArmTemplates/StorageAccountContainer.json")
  parameters = {
    storage_account_name = azurerm_storage_account.backup.name
    container_name       = "default"
  }
}

resource "azurerm_storage_management_policy" "backup" {
  storage_account_id = azurerm_storage_account.backup.id

  rule {
    name    = "BackupDailyRule"
    enabled = true
    filters {
      prefix_match = ["default/daily"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 31
      }
    }
  }

  rule {
    name    = "BackupMonthlyRule"
    enabled = true
    filters {
      prefix_match = ["default/monthly"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 730
      }
    }
  }

  rule {
    name    = "BackupYearlyRule"
    enabled = true
    filters {
      prefix_match = ["default/yearly"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 3650
      }
    }
  }
}
