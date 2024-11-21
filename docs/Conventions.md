# Azure Conventions

> Microsoft Cloud Adoption proposed naming convention can be found [here](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)

## Resource Naming

All Azure resources need to have a unique name, at least within the tenant, there is a reason for this and its to do with Managed Service Identity.  Additionally some resource names also need to be unique globally, like storage accounts or app services.  Where possible within this repo we have used the same extension at the end of all the resource name.

### Management Groups & Subscriptions

> \<Purpose>-\<\* Environment>-\<* AzureRegion>-\<ResourceType>\
> \* - denotes an optional field

\<Purpose> - A Short code for the purpose of the management group or subscription.\
\<Environment> - Optional, the environment being deployed if the container only contains resources for a single environment, e.g. Test, Int, Prod.\
\<AzureRegion> - Optional, a short code for the Azure Region if the only contains resources for a single region, e.g. uks for uksouth.\
\<ResourceType> - A short code for the Azure resource, see below.\

### Policy & Initiatives

Azure Policies use a separate convention as they not only affect a resouce type but have an action as well.  The convention I have adopted is as below.

> \<Group>-\<ResourceType>-\<Action>-\<ResourceType>

\<Group> - The grouping of the Policy.\
\<ResourceType> - A short code for the Azure resource the policy affects.\
\<Action> - The most restrictive action of the Policy, e.g. Deny or Deploy if not Exists.\
\<ResourceType> - A short code for the Azure resource, see below.

### Resource Groups & Resources

Except for the resources listed in the exclusions, all Azure resources should use the following naming convention.

> \<Application>-\<Environment>-\<AzureRegion>-\<ResourceType>-\<\* Usage>-\<\* Instance>\
> \* - denotes an optional field

\<Application> - A short code for the application.\
\<Environment> - The environment being deployed, e.g. Test, Int, Prod.\
\<AzureRegion> - A short code for the Azure Region, e.g. uks for uksouth.\
\<ResourceType> - A short code for the Azure resource, see below.\
\<Usage> - Optional, a description of the usage, where there might be multiple similar resources, e.g. routes. Does not apply for **Resource Groups**\
\<Instance> - Optional, a 3 or 4 digit instance number where there might be multiple resources e.g. multiple App Services.\

#### Exclusions

* Storage Accounts,
  * limitation only AlphaNumeric characters in the name
  * maximum length of 24 characters

## Azure Resources

Placing the resource extension at the end of the naming convention, which is different to the Microsoft best practice, means resources are grouped by name when viewing a complete list and not by the extension. I have found in practice this makes a big difference when viewing a large estate.

## Locations

See [Azure Locations](./Locations.md) for more information, and a list of known locations plus their short codes.

## Azure Resource

See [Azure Resources](./AzureResource.md) for more informaiton, and a list of resource short code's.
