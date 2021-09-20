# Outbound Workflow

## Process

- A member of the HOT makes an empty POST request to `https://<subdomain>.hotosm.org/api/outbound` with the header `apikey` set to the value of the key stored in the NGINX configuration file `/etc/nginx/api_keys.conf`.
- The outbound Logic App initiates a Postgres backup (saved in the outbound storage account).
- The outbound Logic App sends an email to the recipients defined in the configuration file `config.logicapps.sendgridtemplate.outbound.json` (configuration storage account).
- The 510 team connects to the outbound storage account and downloads the database backup file.

## PostgreSQL Backups

### Database Credentials

The credentials for the PostgreSQL database are stored in a `.pgpass` file in the home directory of the root user. The format of the `.pgpass` file is `host:port:database:username:password`. Any of the first four parameters can be substituted with a wildcard '*'.

It is possible to pass a connection string in the format `postgresql://[user[:password]@][host][:port][,...][/dbname][?param1=value1&...]` as a command line argument to `psql` and `pg_dump` but command line arguments are visible when using the ps program which presents a security risk.

## Retrieving Backups from the Outbound Storage Account

User triggered database backups (https://<subdomain>.hotosm.org/api/outbound) are saved in the outbound storage account.

The outbound storage account container can be accessed via the portal, the CLI or Azure Storage Explorer. To access the storage account container either:
- Configure a user in the AD with the Azure 'Storage Blob Data Contributor' role.
- Issue a time limited Shared Access Signature.

### Obtaining a Shared Access Signature - Portal

- Navigate to the `default` container in the outbound storage account.
- Select the 'Shared access tokens' blade.
  - Select 'Key 1' for the 'Signing key'.
  - Select Read and List permissions.
  - Select the Start and Expiry times.
  - Enter any IP address(es) to limit access.
  - Select 'HTTPS Only'.
  - Click 'Generate SAS token and URL'.

If you need to revoke a Shared Access Signature then rotate the keys for the storage account. **Note: all current Shared Access Signatures based on the original key will become invalid.**

### Obtaining a Shared Access Signature - Powershell

Tokens issued using this method (OAuth authentication) are valid for a maximum windows of 7 days from the time they are created.

The account running the Powershell commands must have the 'Storage Blob Data Contributor' role and their IP address must be white listed in the storage account network configuration (if restricting access by IP).

``` PowerShell
$storageAccountName = "sahotweudevoutbound<RANDOM_DIGITS_ALLOCATED_AT_DEPLOYMENT>"

$context = New-AzStorageContext `
  -StorageAccountName $storageAccountName `
  -UseConnectedAccount

$StartTime = Get-Date
$ExpiryTime = $startTime.AddDays(7)

New-AzStorageContainerSASToken `
  -Context $context `
  -Name "default" `
  -Permission rl `
  -Protocol HttpsOnly `
  -StartTime $StartTime `
  -ExpiryTime $ExpiryTime `
  -FullUri `
  -IPAddressOrRange "<IP_ADDRESS_IF_NECESSARY>"
```
