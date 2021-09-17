# Virtual Machine

## Cloud Init

### Troubleshooting

The cloud-init log is located in:

`/var/log/cloud-init.log.`

## NGINX as an API Gateway

NGINX (Open Source) is used as a reverse proxy / API gateway.

https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-1/

## Backups

A VM backup policy is configured as follows:
- Instant recovery snapshots will be retained for 2 days.
- Daily backups will be taken at 19:30 UTC and retained for 31 days.
- Weekly backups will be taken on Sundays at 19:30 UTC and retained for 12 weeks.
- Monthly backups will be taken on the last Sunday of the month at 19:30 UTC and retained for 24 months.
- Annual backups will be taken on the last Sunday in December at 19:30 UTC and retained for 5 years.

## Boot Diagnostics

The Azure VM is configured with a managed Boot Diagnostics storage account.

The screenshot / logs from the storage account can be viewed using the Azure Portal:

VM > Support + troubleshooting > Boot diagnostics
