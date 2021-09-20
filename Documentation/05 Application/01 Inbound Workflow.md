# Inbound Workflow

## Process

- A member of the 510 team POSTs a request to `https://<subdomain>.hotosm.org/api/inbound` with the header `apikey` set to the value of the key stored in the NGINX configuration file `/etc/nginx/api_keys.conf` and the request body containing the GeoJSON data. The content type is set to `application/json`.
- The inbound Logic App validates the GeoJSON data against the GeoJSON schema.
- The inbound Logic App stores the GeoJSON data in the inbound storage account.
- The inbound Logic App sends an email to the recipients defined in the configuration file `config.logicapps.sendgridtemplate.inbound.json` (configuration storage account). The GeoJSON data is saved as an attachment to the email.

### Sending a Request

Verb:
POST

Header:
apikey <NGINX API key>

URI:
`https://<subdomain>.hotosm.org/api/inbound`

Body (application/json):
``` JSON
{ "Key": "geojson data ..." }
```
