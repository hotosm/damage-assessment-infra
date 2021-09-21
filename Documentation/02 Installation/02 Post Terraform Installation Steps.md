# Post Terraform Installation Steps

## Install OMS Agent on the VM.

Installation of the OMS Extension for update management on the Linux VM failed when attempted using Terraform, an ARM Template and in the portal. See the [Known Issues page](../09%20Appendices/02%20Known%20Issues.md) for more information.

### Manual Workaround

- Navigate to the Log Analytics Workspace in the Azure Portal.
- Select the 'Agents management' blade.
- Select the 'Linux servers' tab in the blade window.
- Copy the `wget ...` command from the 'Download and onboard agent for Linux' text box.
- Login to the VM.
- Paste and execute the copied wget command.
- Once the installation has completed on the VM:
  - Navigate to the Log Analytics Workspace resource.
  - Select the 'Virtual Machines' blade.
  - Check that the VM is listed as connected to the workspace.
  - If it's not connected then select the VM and click 'Connect' on the header menu.

## Installing an SSL Certificate using Certbot

Once the Terraform build has completed:
- Obtain the VM's public IP address.
- Add a new 'A' record in the HOT DNS account that links a `hotosm.org` subdomain to the public IP address in Azure. For example `dat.hotosm.org` > `111.222.333.444`.
- Open port 80 on the Network Security Group to allow Certbot callbacks.

### Requesting a SSL Certificate using Certbot

Configure environment:

``` BASH
DOMAIN_NAME=dat.hotosm.org # Subdomain to be confirmed.
EMAIL_ADDRESS_FOR_CERTBOT_NOTIFICATIONS=info@hotosm.org # To be confirmed.
```

Ensure that port 80 is open to all addresses to allow Certbot to make callbacks to the server.

Requesting a certificate **(Max 5 requests per week)**:

``` BASH
sudo certbot --nginx -d $DOMAIN_NAME --email $EMAIL_ADDRESS_FOR_CERTBOT_NOTIFICATIONS --agree-tos --non-interactive --redirect
```

Testing a request of a certificate (use for development as requests don't count towards weekly limit): 

``` BASH
sudo certbot --nginx -d $DOMAIN_NAME --email $EMAIL_ADDRESS_FOR_CERTBOT_NOTIFICATIONS --agree-tos --non-interactive --redirect --test-cert
```
