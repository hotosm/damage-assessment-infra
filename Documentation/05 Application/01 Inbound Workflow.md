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

### Example GeoJSON Data (Sourced from Wikipedia)

``` JSON
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [102.0, 0.5]
      },
      "properties": {
        "prop0": "value0"
      }
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": [
          [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
        ]
      },
      "properties": {
        "prop0": "value0",
        "prop1": 0.0
      }
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
            [100.0, 1.0], [100.0, 0.0]
          ]
        ]
      },
      "properties": {
        "prop0": "value0",
        "prop1": { "this": "that" }
      }
    }
  ]
}
```
