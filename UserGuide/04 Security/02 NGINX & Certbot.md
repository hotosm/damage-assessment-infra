# NGINX & Certbot

## Introduction

NGINX provides reverse proxying and SSL offloading functionality.

The Certbot program manages the initial SSL certificate request and renewal. It also updates the NGINX configuration file(s) to redirect requests from port 80 to port 443.

## Certbot Execution

Certbot is run daily by a CRON job. The Certbot tool will auto-renew the SSL certificate before it expires. For HTTP validation, Certbot requires that port 443 is open to all IP addresses (the Let's Encrypt service runs on various servers on CDN networks so we're not able to restrict to a range of Let's Encrypt IP addresses).

## Redirection From http to https

Certbot updates the NGINX configuration file and adds an instruction to automatically redirect an http request to an https request. It does this by configuring NGINX to return a 301 status code to the client when a http request is received.

If a POST request is sent to the server over http then a returned status code of 301 will cause the client to change the request type from POST to GET before trying again. This will cause the POST request body to be ignored and the request will fail on the upstream server. This is good practice as it's not desirable to compensate for HTTP POST requests being sent over an unsecured http connection. When making a HTTP POST request ensure that the protocol is set to https.

## Testing

To test the security of the site navigate to the SSL Labs testing page, including the domain name to be tested as a query string parameter:

`https://www.ssllabs.com/ssltest/analyze.html?d=<DOMAIN_NAME>`

E.G.

`https://www.ssllabs.com/ssltest/analyze.html?d=dat.hotosm.org`
