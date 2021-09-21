# Maintenance Tasks

## Rotate the NGINX API Key

- Create a new API Key:
    ```
    openssl rand -base64 32
    ```
- Update the value in the file `/etc/nginx/api_keys.conf`.

## Rotate the Keys to the Storage Accounts

https://docs.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-portal#rotate-access-keys

## Rotate the Keys to the Logic Apps

- Navigate to the 'Access Keys' blade for the Logic App.
- Select the key to regenerate and click the 'Regenerate Access Key' button.
- Navigate to the 'Overview' blade and select the 'Trigger History' tab on the page.
- Copy the 'Callback URL [POST]' value.
- Overwrite the URL and query string parameters in the NGINX configuration file `/etc/nginx/conf.d/<DOMAIN_NAME>.conf`.
- Reload NGINX `nginx -s reload`.
