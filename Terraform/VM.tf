resource "azurerm_linux_virtual_machine" "app" {
  name                            = "vm-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01"
  resource_group_name             = azurerm_resource_group.app.name
  location                        = azurerm_resource_group.app.location
  size                            = "Standard_B1ms"
  computer_name                   = "vm-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01"
  admin_username                  = var.vm_admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.vm.id]

  identity {
    type = "SystemAssigned"
  }

  dynamic "admin_ssh_key" {
    for_each = var.ssh_keys
    content {
      username   = var.vm_admin_username
      public_key = admin_ssh_key.value
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "vm-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01-disk-os"
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }

  boot_diagnostics {
    # An empty block or 'storage_account_uri = null' indicates
    # that a managed boot diagnostics storage account is created
    # and assigned to the instance.
    # https://github.com/hashicorp/terraform-provider-azurerm/issues/9814
    storage_account_uri = null
  }

  custom_data = (base64encode(templatefile(
    var.vm_cloud_init_script, {
      vm_admin_username                = "${var.vm_admin_username}",
      sa_inbound                       = "${azurerm_storage_account.inbound.name}",
      sa_outbound                      = "${azurerm_storage_account.outbound.name}",
      sa_backup                        = "${azurerm_storage_account.backup.name}",
      la_inbound_trigger_url           = "${local.la_inbound_trigger_url}",
      la_inbound_trigger_query_string  = "${local.la_inbound_trigger_query_string}",
      la_outbound_trigger_url          = "${local.la_outbound_trigger_url}",
      la_outbound_trigger_query_string = "${local.la_outbound_trigger_query_string}",
      domain_name                      = "${var.domain_name}",
      public_ip_address                = "${azurerm_public_ip.pip.ip_address}",
      nginx_api_key                    = "${var.nginx_api_key}",
      postgres_user_name               = "${var.postgres_user_name}",
      postgres_password                = "${var.postgres_password}"
  })))

  depends_on = [
    azurerm_storage_account.inbound,
    azurerm_storage_account.outbound,
    azurerm_storage_account.backup,
    azurerm_template_deployment.logicappinbound
  ]
}

# ------------------------------------------------------------------------------
# Data Disk
# ------------------------------------------------------------------------------
resource "azurerm_managed_disk" "vmdata" {
  name                 = "vm-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01-disk-data"
  location             = azurerm_resource_group.app.location
  resource_group_name  = azurerm_resource_group.app.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 64
}

resource "azurerm_virtual_machine_data_disk_attachment" "vmdata" {
  managed_disk_id    = azurerm_managed_disk.vmdata.id
  virtual_machine_id = azurerm_linux_virtual_machine.app.id
  lun                = "10"
  caching            = "ReadWrite"
}

# ------------------------------------------------------------------------------
# VM Backup
# ------------------------------------------------------------------------------
resource "azurerm_recovery_services_vault" "main" {
  name                = "rsv-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01"
  location            = azurerm_resource_group.sharedservices.location
  resource_group_name = azurerm_resource_group.sharedservices.name
  sku                 = "Standard"
  # TODO-SDE Set this to true for production deployment.
  soft_delete_enabled = false
}

resource "azurerm_backup_policy_vm" "vm" {
  name                = "rsv-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01-backuppolicy-vm"
  resource_group_name = azurerm_resource_group.sharedservices.name
  recovery_vault_name = azurerm_recovery_services_vault.main.name

  timezone = "UTC"

  instant_restore_retention_days = 5

  backup {
    frequency = "Daily"
    time      = "19:30"
  }

  retention_daily {
    count = 31
  }

  retention_weekly {
    count    = 12
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 24
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }

  retention_yearly {
    count    = 5
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["December"]
  }
}

resource "azurerm_backup_protected_vm" "vm" {
  resource_group_name = azurerm_resource_group.sharedservices.name
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  source_vm_id        = azurerm_linux_virtual_machine.app.id
  backup_policy_id    = azurerm_backup_policy_vm.vm.id
}

# ------------------------------------------------------------------------------
# Role Assignments
# ------------------------------------------------------------------------------
# Grant the outbound logic app access to use the 'Run Command' functionality on the VM (via HTTPS POST request).
resource "azurerm_role_assignment" "laoutboundtovm" {
  scope              = azurerm_linux_virtual_machine.app.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.virtualmachinecontributor.id}"
  principal_id       = azurerm_template_deployment.logicappoutbound.outputs["principalId"]
}

# ------------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------------
locals {
  la_inbound_trigger_url           = regex("(.*)\\?.*", azurerm_template_deployment.logicappinbound.outputs["triggerUrl"]).0
  la_inbound_trigger_query_string  = regex(".*\\?(.*)", azurerm_template_deployment.logicappinbound.outputs["triggerUrl"]).0
  la_outbound_trigger_url          = regex("(.*)\\?.*", azurerm_template_deployment.logicappoutbound.outputs["triggerUrl"]).0
  la_outbound_trigger_query_string = regex(".*\\?(.*)", azurerm_template_deployment.logicappoutbound.outputs["triggerUrl"]).0
}
