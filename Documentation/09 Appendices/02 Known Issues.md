# Appendix 2 - Known Issues

## VM OMS Extension

Installation of the OMS Extension for update management on the Linux VM failed when attempted using Terraform, an ARM Template and in the portal.

A manual workaround exists which is documented in the file: [02 Post Terraform Installation Steps.md](../02%20Installation/02%20Post%20Terraform%20Installation%20Steps.md)

### Background

There are [known issues](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/issues-using-vm-extensions-python-3) with installing Python 2 based VM Extensions in Python 3 ([the default on Ubuntu since version 18.04 LTS](https://wiki.ubuntu.com/Python)) enabled environments.

### Attempted Deployment using an ARM Template

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

Integrate the VM Extension into the ARM Template at a later date after it has been upgraded to use Python 3.

## Tags on VM OS Disk

It's not currently possible to assign tags to the OS disk of the Virtual Machine using Terraform. Please do this manually if required.
