# Logic Apps

## Inbound Logic App

Process:
- HTTP POST request triggers execution of the inbound Logic App:
  - POST `subdomain.hotosm.org/api/inbound`
  - Headers:
    - apikey `<<Value stored in /etc/nginx/api_keys.conf>>`
    - Content-Type application/json
  - Body:
    - GeoJSON document
- Format of the GeoJSON document in the body of the request is validated using the GeoJSON schema (https://geojson.org/schema/GeoJSON.json).
- The body of the request is saved to a `.json` file in the mounted Azure Storage Account `/mnt/storageinbound`.
- An email is sent to the recipients specified in the block blob `default/config.logicapps.sendgridtemplate.inbound.json` which is in the configuration storage account. The email has an attachment with the GeoJSON content of the request body.

## Outbound Logic App

- HTTP POST request triggers execution of the outbound Logic App:
  - POST `subdomain.hotosm.org/api/outbound`
  - Headers:
    - apikey `<<Value stored in /etc/nginx/api_keys.conf>>`
  - Body:
    - None
- Logic App executes an Azure VM Run Command which calls the backup script `/root/scripts/db_backup.sh` on the VM.
- Backup script runs Postgres backup and saves the backup files in the outbound storage account `/mnt/storageoutbound`
- An email is sent to the recipients specified in the block blob `default/config.logicapps.sendgridtemplate.outbound.json` which is in the configuration storage account.

## Process for Maintaining Logic Apps

Reference:

https://docs.microsoft.com/en-us/azure/logic-apps/manage-logic-apps-with-visual-studio

### Prerequisites

Visual Studio 2019 or greater
Azure Logic Apps Tools for Visual Studio

### Build and Test

1. Deploy the resources from the application to a temporary Resource Group using Terraform.
1. Using Visual Studio:
  1. Download the Logic App using the cloud explorer (https://docs.microsoft.com/en-us/azure/logic-apps/manage-logic-apps-with-visual-studio#download-from-azure).
  1. Edit the Logic App(s) as necessary.
  1. Publish the revised changes to the temporary RG.
1. Test the changes in the temporary RG.
1. Using Visual Studio, download the changes to a local VS resource group project.
1. Save the local changes in a code repository.

### Generate ARM Template - Option 1

Copy the template and parameter file (downloaded using Visual Studio in the previous section).

### Generate ARM Template - Option 2

1. Install the LogicAppTemplate PowerShell module (**run as administrator**):

    `Install-Module -Name LogicAppTemplate`

1. Generate an ARM Template

    ``` PowerShell
    $subscriptionId = '<SUBSCRIPTION_ID>'
    $resourceGroup = '<RESOURCE_GROUP_NAME>'
    $logicAppName = '<LOGIC_APP_NAME>'

    az login

    $parameters = @{
        Token = (az account get-access-token | ConvertFrom-Json).accessToken
        LogicApp = $logicAppName
        ResourceGroup = $resourceGroup
        SubscriptionId = $subscriptionId
        Verbose = $true
    }

    Get-LogicAppTemplate @parameters | Out-File .\la-hot-weu-dev-inbound.json
    ```

### Deploy to Production Environment

1. Edit the ARM template:
  - delete the lines: `"principalId": "<value>"` and `"tenantId": "<value>"`. These are assigned on creation and have to be null / empty in the template.
  - Add an 'outputs' block to return the SystemAssigned principalId and the trigger URL of the Logic App:
    ``` JSON
    "outputs": {
      "principalId": {
        "type": "string",
        "value": "[reference(resourceId('Microsoft.Logic/workflows', parameters('LogicAppName')), '2019-05-01', 'Full').Identity.principalId]"
      },
      "triggerUrl": {
        "type": "string",
        "value": "[listCallbackURL(concat(resourceId('Microsoft.Logic/workflows/', parameters('LogicAppName')), '/triggers/request'), '2016-06-01').value]"
    }
    }
    ```

https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-powershell

``` PowerShell
New-AzResourceGroupDeployment -Name 'DeploymentLogicAppInbound' `
  -ResourceGroupName 'rg-hot-weu-dev-01' `
  -TemplateFile 'C:\Path\la-hot-weu-dev-inbound.json' `
  -TemplateParameterFile 'C:\Path\la-hot-weu-dev-inbound.parameters.json'
```
