# Application

## Managed Identities

The VM and the Logic Apps run in the context of [Azure Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview).

Utilising managed identities allows the use of Active Directory to control which resources can be accessed. For example the config, inbound and outbound storage accounts are configured to allow access to the managed identities of the Logic Apps for specific roles. Also, the outbound Logic App is granted permission to execute a Run Command on the VM (to initiate a database backup).

View the Access Control (IAM) blade on the storage accounts or on the VM to see this in practice.

## Role Based Access Control

Active directory groups are defined in the Terraform build files that map to the Resource Groups. This allows Role Based Access Control to the Resource Groups to be encapsulated in the AD groups.

The groups are listed in the `AdGroups.tf` file.

## Shared Access Signatures

Shared Access Signatures (SAS) are time limited 'tokens' that allow access to Azure resources by external entities.

The outbound storage account can be configured to allow access to the database backups by the 510 team. See the Outbound Workflow page in the Application section for details on how to generate a SAS token.
