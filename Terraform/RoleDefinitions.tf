# Role Definitions for resource groups.
data "azurerm_role_definition" "owner" {
  name = "Owner"
}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "reader" {
  name = "Reader"
}

# Role Definitions for system assigned managed identities.
data "azurerm_role_definition" "storageblobreader" {
  name = "Storage Blob Data Reader"
}

data "azurerm_role_definition" "storageblobcontributor" {
  name = "Storage Blob Data Contributor"
}

data "azurerm_role_definition" "virtualmachinecontributor" {
  name = "Virtual Machine Contributor"
}

data "azurerm_role_definition" "keyvaultsecretsuser" {
  name = "Key Vault Secrets User"
}

# Required for Terraform deployment principal.
data "azurerm_role_definition" "keyvaultsecretsadministrator" {
  name = "Key Vault Administrator"
}