# Configuration

## Application Configuration

Application configuration data is saved as block blobs in the storage account `sahotweudevconfig`.

For example, the configuration blob for the SendGrid template in the Inbound Workflow Logic App is called `config.logicapps.sendgridtemplate.inbound.json` and is stored in the `/default` container.

The Azure Portal can be used to download / upload / edit blobs. Azure Storage Explorer can be used to download / upload blobs.

When uploading a revised version of a configuration blob ensure that the file extension is set as `.json`. This will set the blob content type to `application/json`. If the blob content type isn't `application/json` then the configuration initialisation process will fail.

## Configuring the Outbound Storage Account for Access by the 510 Team

Two options to retrieve database backups from the outbound storage account are:

- Using Azure Portal.
- Using Azure Storage Explorer.

### Retrieving Database Backups using the Azure Portal

- Create a user in the HOT tenant's AD and grant that user permission to only read / list blobs in the outbound storage account's `default` container.
- A member of the 510 team can log in to the HOT's tenant and navigate to the outbound storage account and default container to view / download available database backups (blobs).

### Retrieving Database Backups using Azure Storage Explorer

- A member of the HOT generates a time limited Shared Access Signature (SAS) URL for the `default` container with read / list permissions.
- The 510 team downloads and installs Azure Storage Explorer.
- The 510 team creates a connection to the container using the SAS URL in Azure Storage Explorer to view / download available database backups (blobs).
- The SAS URL will need to be refreshed once the original time window expires.

## GeoJSON Schema

The inbound Logic App validates the request body against the GeoJSON schema. During project development there wasn't sufficient time remaining to dynamically set the GeoJSON schema in the Logic App so this was hard-coded. If the GeoJSON schema needs to be updated then the Logic App will need updating (see the Logic App page) with the revised schema.

A copy of the GeoJSON schema is saved in the configuration file `config.logicapps.sendgridtemplate.schema.json` (configuration storage account).
