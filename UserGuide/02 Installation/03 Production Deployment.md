# Production Deployment Tasks

Files in the repository are annotated with TODO-<REFERENCE_CODE>. Cross reference these placeholders here:

## TODO-SDE

Soft delete protection for the VM backup has been disable while developing / testing the Terraform build. When enabled it prevents Terraform from destroying the recovery services vault - this has to be done manually.

### Action

Set the soft_delete_enabled property to true before deploying the solution to production.
