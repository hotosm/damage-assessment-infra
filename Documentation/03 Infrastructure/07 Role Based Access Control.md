# Role Based Access Control (RBAC)

## AD Groups

The following AD groups have been created in the organisation's Tenant:

|AD Group|Mapped to Equivalent Roles in Resource Group(s)*|
|---|---|
|AZGRP_RG_App_Owners<br>AZGRP_RG_App_Contributors<br>AZGRP_RG_App_Readers|rg-hot-*loc*-*env*-app|
|AZGRP_RG_Secrets_Owners<br>AZGRP_RG_Secrets_Contributors<br>AZGRP_RG_Secrets_Readers|rg-hot-*loc*-*env*-secrets|
|AZGRP_RG_Storage_Owners<br>AZGRP_RG_Storage_Contributors<br>AZGRP_RG_Storage_Readers|rg-hot-*loc*-*env*-storage|
|AZGRP_RG_Network_Owners<br>AZGRP_RG_Network_Contributors<br>AZGRP_RG_Network_Readers|rg-hot-*loc*-*env*-network|
|AZGRP_Maintenance_Owners<br>AZGRP_Maintenance_Contributors<br>AZGRP_Maintenance_Readers|rg-hot-*loc*-*env*-loganalytics<br>rg-hot-*loc*-*env*-sharedservices|

\* Additional mappings can be configured as required.

## RBAC for System Assigned Managed Identities

The following resources have system assigned managed identities. This allows AD to manage access between resources (e.g. access to storage account by the Logic Apps).

- Logic App - Inbound
- Logic App - Outbound
- Automation Account
- Virtual Machine

Permissions for each resource can be viewed by opening the 'Access control (IAM)' blade in the resource page.
