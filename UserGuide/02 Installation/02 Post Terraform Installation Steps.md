# Post Terraform Installation Steps

## Requesting a SSL Certificate using Certbot

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

Restrict port 80 to specific addresses.

## Add OperationalInsights Module and link VM for Update Management

https://docs.microsoft.com/en-us/azure/automation/update-management/enable-from-runbook
