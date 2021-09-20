# Post Terraform Installation Steps

## Configuration of SSL Certificate using Certbot

Once the Terraform build has completed:
- Obtain the VM's public IP address.
- Add a new 'A' record in the HOT DNS account that links a subdomain 'dat' to the public IP address in Azure. For example 'dat.hotosm.org' > '111.222.333.444'.
- Open port 80 on the Network Security Group to allow Certbot callbacks.

### Requesting a SSL Certificate using Certbot

Configure environment:

``` BASH
DOMAIN_NAME=dat.hotosm.org # Subdomain to be confirmed.
EMAIL_ADDRESS_FOR_CERTBOT_NOTIFICATIONS=info@hotosm.org # To be confirmed.
```

Open port 80 to all addresses to allow Certbot to make callbacks to the server.

Requesting a certificate **(Max 5 requests per week)**:

``` BASH
sudo certbot --nginx -d $DOMAIN_NAME --email $EMAIL_ADDRESS_FOR_CERTBOT_NOTIFICATIONS --agree-tos --non-interactive --redirect
```

Testing a request of a certificate (use for development as requests don't count towards weekly limit): 

``` BASH
sudo certbot --nginx -d $DOMAIN_NAME --email $EMAIL_ADDRESS_FOR_CERTBOT_NOTIFICATIONS --agree-tos --non-interactive --redirect --test-cert
```
