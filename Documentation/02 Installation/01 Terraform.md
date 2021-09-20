# Installation Steps

## Deployment of Infrastructure Resources using Terraform

### Configure Terraform Variables

- Configure values in the Terraform variables file `terraform.tfvars`, or in Terraform Cloud, as required:
    ``` BASH
    tenant_id = "<TENANT_ID>"
    subscription_id = "<SUBSCRIPTION_ID>"

    region  = "westeurope"
    org_abb = "hot"
    reg_abb = "weu"
    env_abb = "dev"

    vm_admin_username = "hotadmin"

    ssh_keys = {
    "<SSH_KEY_NAME_1>" = "<SSH_KEY_VALUE_1>",
    "<SSH_KEY_NAME_2>" = "<SSH_KEY_VALUE_2>",
    "<SSH_KEY_NAME_3>" = "<SSH_KEY_VALUE_3>",    }

    sa_inbound_ip_rules = [
    "xxx.xxx.xxx.xxx",
    "yyy.yyy.yyy.yyy"
    ]

    sa_outbound_ip_rules = [
    "xxx.xxx.xxx.xxx",
    "yyy.yyy.yyy.yyy"
    ]

    sa_config_ip_rules = [
    "xxx.xxx.xxx.xxx",
    "yyy.yyy.yyy.yyy"
    ]

    nsg_allowed_addresses_ssh = [
    "xxx.xxx.xxx.xxx",
    "yyy.yyy.yyy.yyy"
    ]

    nsg_allowed_addresses_http = [
    "xxx.xxx.xxx.xxx",
    "yyy.yyy.yyy.yyy"
    ]

    nsg_allowed_addresses_https = [
    "xxx.xxx.xxx.xxx",
    "yyy.yyy.yyy.yyy"
    ]

    domain_name = "<sub_domain>.hotosm.org"
    ```

- Generate a new API key for NGINX. This will be used to configure NGINX to only authorise requests with a matching `apikey` header. Securely share this API Key with people who will be calling the API.
    ``` BASH
    openssl rand -base64 32
    ```

- Configure values in the secrets variables file `secrets.auto.tfvars`, or in Terraform Cloud, as required.
    ``` BASH
    hot_sendgrid_api_key = "<SENDGRID_API_KEY>"
    nginx_api_key = "<NGINX_API_KEY>"
    postgres_user_name = "<POSTGRES_USER_NAME>"
    postgres_password = "<POSTGRES_PASSWORD>"
    ```

### Configure Cloud-Init YAML File

The file `VM-Cloud-Init.yaml` contains the VM setup instructions in [Cloud-Init](https://cloudinit.readthedocs.io/en/latest/) syntax. The Cloud-Init steps are run as part of the Terraform VM setup and are called from the `custom_data` element. The `custom-data` element also performs variable substitution in the `VM-Cloud-Init.yaml` file.

Installation of the OSM-Seed database container has been added to this file to enable implementation and testing of the database backup processes. The steps for the database container installation have been left in place but commented out so that they can be used as an example if the full OSM-Seed installation is added to the Cloud-Init setup.

### Application Configuration Files

The application configuration files are contained in the `/Configuration` directory. These files are copied to the configuration storage account. The Logic Apps for the inbound and outbound workflows read the configuration files each time they run.

The configuration files for the inbound and outbound workflows are JSON documents describing the settings for the body of the SendGrid email service. Both configuration files should conform to the SendGrid email JSON schema - also saved in the `/Configuration` directory as `SendGridTemplateSchema.json`.

Update these files as required. For example:
- Set the email subject.
- Set the sender information (from address, sender).
- Add recipients (To, Cc).
