# Installation

## Steps

### Deployment of Infrastructure Resources using Terraform

- Configure values in the Terraform variables file `terraform.tfvars` as required:
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
- Configure values in the secrets variables file `secrets.auto.tfvars` as required.
    ``` BASH
    hot_sendgrid_api_key = "<SENDGRID_API_KEY>"
    nginx_api_key = "<NGINX_API_KEY>"
    postgres_user_name = "<POSTGRES_USER_NAME>"
    postgres_password = "<POSTGRES_PASSWORD>"
    ```

- Run the Terraform installation.

### Configuration of SSL Certificate using Certbot

- Add a new 'A' record in the HOT DNS account that links a subdomain 'dat' to the public IP address in Azure. For example 'dat.hotosm.org' > '111.222.333.444'.
- Open port 80 on the Network Security Group to allow Certbot callbacks.
