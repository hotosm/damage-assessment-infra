# Restore Workflow

Database backups are taken every day and retained as per the policy defined in the [storage page](../03%20Infrastructure/02%20Storage.md).

The backup storage account is mounted to the virtual machine in the `/mnt/storagebackup` directory.

Retrieve the backup file required and follow the [Postgres restore process](https://www.postgresql.org/docs/8.1/backup.html).
