# Appendix 1 - Design Decisions

## Application Configuration

Settings that may need to be changed during the lifetime of the solution are stored as configuration items.

Azure has an [Application Configuration](https://azure.microsoft.com/en-us/services/app-configuration/#overview) offering. The [Free Tier](https://azure.microsoft.com/en-us/pricing/details/app-configuration/#pricing) of this product has a limit of 1,000 requests per day which is low for serverless applications where a configuration request will be made for each execution. The [Standard Tier](https://azure.microsoft.com/en-us/pricing/details/app-configuration/#pricing) is chargeable at USD 438 / year.

### Design Decision

Store application configuration items in Azure Storage Blob Service. This provides native functionality to store unstructured data for a few US cents per month. There is no limit on the number of requests and the charge for tens of thousands of requests is also negligible.

Configuration items stored in Azure Blob Service can easily be viewed / changed using the Azure Portal or Azure Storage Explorer.
