# Introduction

This is the Azure cloud infrastructure build for the Humanatarian OpenStreetMap Team's Damage Assessment project.

The solution primarily consists of an Azure virtual machine running Ubuntu 20.04 LTS / NGINX and two Azure Logic Apps (one for the inbound workflow; one of the outbound workflow).

OSM-Seed and RapiD Editor are hosted on Docker which is installed on the VM.

The inbound workflow is invoked by making an HTTP POST request to an endpoint exposed via NGINX. The body of the request should contain GeoJSON data to be imported using the RapiD Editor. The workflow sends an email to HOT members notifying them that a new GeoJSON dataset has been received.

The outbound workflow is invoked by making an HTTP POST request to an endpoint exposed via NGINX. The workflow runs a Postgres database backup script on the VM and saves the backup to a storage account which can be accessed by the 510 team using a SAS token based URL.
