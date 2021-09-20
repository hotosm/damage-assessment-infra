# Network

## Network Security Group

The Virtual Network has a subnet that contains the VM. The subnet has a Network Security group applied. Currently this allows traffic on ports 22, 80 and 443 from defined ip addresses.

Details of the NSG rules are contained in the `Network.tf` file and associated variables.

Note: Single IP addresses are referened with the Terraform property `source_address_prefix`; multiple IP addresses are referenced with the Terraform property `source_address_prefixes`.

## Storage Accounts

Storage accounts have their own network rules applied. See the Terraform for each storage account for details on the security configuration.
