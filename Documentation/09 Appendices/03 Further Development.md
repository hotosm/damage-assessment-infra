# Appendix 3 - Further Development

Areas for potential further development.

## OSM-Seed

Update the `Cloud-Init.yaml` file with OSM-Seed build steps and configuration items. See the placeholders `TODO-OSM1`, `TODO-OSM2` and `TODO-OSM3`.

## Inbound Logic App

- Dynamically load GeoJSON schema from configuration storage account / remove hard-coded schema in Logic App.

## NGINX

- Store NGINX API key in Key Vault and configure process (possibly Azure EventGrid) to automatically update the file `/etc/nginx/api_keys.conf` when the key is rotated (and updated in Key Vault).
