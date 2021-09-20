# Resource Groups

## Naming Convention

Resource groups in the solution are named as follows:

`rg-<org>-<loc>-<env>-<area>`

Where:
- `<org>`  = Organisation abbreviation (default: 'hot').
- `<loc>`  = Location abbreviation (default: 'weu' for Western Europe).
- `<env>`  = Environment (default: 'dev' for Development).
- `<area>` = Solution area.

The values above are configurable by setting Terraform variables.

## Default Resource Groups

The following resource groups are created as part of the default Terraform build:

- `rg-hot-weu-dev-app` (Application)
- `rg-hot-weu-dev-loganalytics` (Log Analytics, Automation Account)
- `rg-hot-weu-dev-network` (Network components)
- `rg-hot-weu-dev-secrets` (Key Vault)
- `rg-hot-weu-dev-sharedservices` (Recovery Services Vault)
- `rg-hot-weu-dev-storage` (Storage accounts)
