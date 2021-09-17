# Appendix 2 - Known Issues

## OMS Extension

Installation of the OMS Extension for update management on the Linux VM is currently failing. Installation was attempted via Terraform, ARM Template and manually in the portal.

Step 5 in this StackOverflow article describes the steps necessary to install the extension using an ARM Template:
https://stackoverflow.com/a/61508162/2463368

Pre-requisites (Log Analytics Workflow, Automation Account, Workflow > Automation Account Link, Updates Solution) have been installed using the ARM Template.

### References

https://docs.microsoft.com/en-us/azure/azure-monitor/vm/resource-manager-vminsights

https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/oms-linux#extension-schema

### ARM Template 

Add to the resources[] array in the `LogAnalyticsWorkspaceAndAutomationAccount.json` file.

``` JSON
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "name": "[concat(parameters('vmName'), '/OMSExtension')]",
      "apiVersion": "2018-06-01",
      "location": "[parameters('location')]",
      "dependsOn": [],
      "properties": {
        "publisher": "Microsoft.EnterpriseCloud.Monitoring",
        "type": "OmsAgentForLinux",
        "typeHandlerVersion": "1.13",
        "settings": {
          "workspaceId": "[reference(parameters('workspaceName'), '2015-03-20').customerId]"
        },
        "protectedSettings": {
          "workspaceKey": "[listKeys(parameters('workspaceName'), '2015-03-20').primarySharedKey]"
        }
      }
    }
```

### Next Steps

If time allows, raise an issue on GitHub.

Attempt the installation at a later date when installation issues with the VM extension may have been resolved.
