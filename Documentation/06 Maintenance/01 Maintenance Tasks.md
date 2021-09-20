# Maintenance Tasks

## Rotate the NGINX API Key

- Create a new API Key:
    ```
    openssl rand -base64 32
    ```
- Update the value in the file `/etc/nginx/api_keys.conf`.

## Rotate the Keys to the Storage Accounts

TODO

## Rotate the Keys to the Logic Apps

TODO

- Copy the new Shared Access Signatures (inbound and outbound) in the NGINX configuration file `/etc/nginx/conf.d/<DOMAIN_NAME>.conf`.
