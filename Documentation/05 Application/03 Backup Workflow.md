# Backup Workflow

The backup workflow consists of a BASH script `/root/scripts/db_backup.sh` on the VM that is executed by CRON jobs defined in the `/etc/cron.d/database_backup` file.

The script iterates through the Postgres databases in the OSM-Seed databases container, takes a backup of each database and saves them in the `/mnt/storagebackup/daily`, `/mnt/storagebackup/monthly` or `mnt/storagebackup/yearly` directory.

The Postgres user name and password are configured in the `/root/.pgpass` file. This is defined in the file `VM-Cloud-Init.yaml` which is configured using Terraform variables.

The database backup script adds log entries in the `/var/log/hot` directory.
