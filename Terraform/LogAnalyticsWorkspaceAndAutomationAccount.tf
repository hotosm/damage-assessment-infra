# Used an ARM Template for deploying the Log Analytics Workspace
# and Automation Account as Terraform configuration was throwing
# a dependency error when creating LAW / AA and then trying to
# link the two.

resource "azurerm_template_deployment" "law_and_aa" {
  name                = "la-${var.org_abb}-${var.reg_abb}-${var.env_abb}-law_and_aa"
  resource_group_name = azurerm_resource_group.loganalytics.name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/ArmTemplates/LogAnalyticsWorkspaceAndAutomationAccount.json")
  parameters = {
    workspaceName                = "law-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01"
    sku                          = "pergb2018"
    dataRetention                = "30" # Terraform can't pass int so have to pass string then convert to int in the ARM template.
    workspaceCappingDailyQuotaGb = "5"  # Terraform can't pass int so have to pass string then convert to int in the ARM template.
    location                     = azurerm_resource_group.loganalytics.location
    automationAccountName        = "aa-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01"
  }
  depends_on = [
    azurerm_linux_virtual_machine.app
  ]
}

# Terraform Option:

#resource "azurerm_log_analytics_workspace" "main" {
#  name                = "law-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01"
#  location            = azurerm_resource_group.loganalytics.location
#  resource_group_name = azurerm_resource_group.loganalytics.name
#  sku                 = "PerGB2018"
#  retention_in_days   = 30
#  
#  # Intended to limit costs on a PAYG model (currently USD 2.99 / GB).
#  # Can be increased if necessary.
#  # https://azure.microsoft.com/en-gb/pricing/details/monitor/
#  daily_quota_gb      = 2
#}

# Automation Account
#resource "azurerm_automation_account" "main" {
#  name                = "aa-${var.org_abb}-${var.reg_abb}-${var.env_abb}-01"
#  resource_group_name = azurerm_resource_group.sharedservices.name
#  location            = azurerm_resource_group.sharedservices.location
#
#  sku_name = "Basic"
#
#  depends_on = [
#    azurerm_log_analytics_workspace.main
#  ]
#}

# Link Automation Account to Log Analytics Workspace.
#resource "azurerm_log_analytics_linked_service" "aalaw" {
#  resource_group_name = azurerm_resource_group.sharedservices.name
#  workspace_id        = azurerm_log_analytics_workspace.main.id
#  read_access_id      = azurerm_automation_account.main.id
#
#  depends_on = [
#    azurerm_log_analytics_workspace.main,
#    azurerm_automation_account.main
#  ]
#}
