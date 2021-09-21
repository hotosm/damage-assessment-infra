# Azure Storage

## References

Mount an Azure Storage File Share to Linux

https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux?tabs=smb311

## Storage Accounts

Four storage accounts are included in the solution. Separate storage accounts are implemented to allow configuration of different permissions and storage lifecycle policies.

- Backup (database backups)
- Configuration (JSON configuration files used by the Logic Apps)
- Inbound
- Outbound

## Database Backups

A database backup is taken at 02:00 UTC every day.

Database backups are triggered by CRON jobs defined in the file `/etc/cron.d/database_backup`.

The backups are saved in the backup storage account which is mounted to the `/mnt/storagebackup` directory.
- Daily backups are stored in the `/mnt/storagebackup/daily` directory.
- Monthly backups are stored in the `/mnt/storagebackup/monthly` directory.
- Yearly backups are stored in the `/mnt/storagebackup/yearly` directory.

### Storage Lifecycle Policy

A storage lifecycle policy rule has been configured on the backup storage account:
- Daily Directory:
  - If a blob hasn't been modified in the previous 31 days then delete it.
- Monthly Directory:
  - If a base blob hasn't been modified in the previous 30 days then move it to the cool access tier.
  - If a base blob hasn't been modified in the previous 90 days then move it to the archive access tier.
  - If a base blob hasn't been modified in the previous 730 days then delete it.
- Yearly Directory:
  - If a base blob hasn't been modified in the previous 30 days then move it to the cool access tier.
  - If a base blob hasn't been modified in the previous 90 days then move it to the archive access tier.
  - If a base blob hasn't been modified in the previous 3650 days then delete it.

## Outbound Workflow Storage Account

### Storage Lifecycle Policy

A storage lifecycle policy rule has been configured on the backup storage account:
- If a base blob hasn't been modified in the previous 30 days then move it to the cool access tier.
- If a base blob hasn't been modified in the previous 90 days then move it to the archive access tier.
- If a base blob hasn't been modified in the previous 365 days then delete it.
