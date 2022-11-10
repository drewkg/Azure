# Introduction

For organisations that use the Microsoft Azure DevOps range of services, the use of Microsoft hosted Agents is a good starting point for automating build services.
However, there are multiple reasons why an organisation would want to host and register their own agents.  Some of the reasons could be:

* Security
* Different Toolset
* Backwards Compatability

What ever the reasons are there are several ways to go about hosting your own Agent. However one of the best ways, if you are using Azure, is to use a Virtual Machine Scale Set backed hosted pool. This gives you the ability to scale the pool as demand grows, and to shrink the pool during low demand times thus saving costs. However this ability does come with a cost of increases manageability.

This section, aims to provide an outline of one such solution to the issue and to provide a base deployment that can then be expanded for your own particular requirements.

## Architecture

There are several parts to a Azure DevOps Service VMSS backed hosted pool, listed below are some of the technical sections:

* Connectivity, to at least Azure devOps Service.
* Azure Virtual Macine Scale Set, this should be one per pool in Azure DevOps.
* Virtal Machine Images, if none of the Azure market palce images fulfil your requirements.
  * Connectivityduring builds of the images.
* Azure Shared Image Gallery, for hosting any custom images.

## Management

Some areas of consideration to take into account

* Ability to recreate the Virtual Machine Images, at least to apply any latest patches.
* Versioning of Agent Pools, this allows the solution to take into account different tool sets going forward.

## Solution

So we have three interelated areas for a complete solution.  Taking into account the fact a image build can take longer than the allowed build time on a Microsoft hosted agent, the first agent VMSS Agent pool should always be a basic Windows / Linux image.  If there is a requirement for custom images after this, they can then utilize the self hosted pool for building, as there are no particular requirements for an installed toolset beyond the inbuilt capability.

The folder AzDO_AgentEnvironment will deploy the following Azure resources, no parameter file necessary.

* Network Security Group
* Virtual Network
  * Single Subnet
* VMSS with a Windows 2019 base image

In addition it can also

* Peer with a hub network
* Apply route for all traffic external to the virtual network
* Deploy multiple subnets, one per VMSS
* Deploy multiple VMSS, depending on an array of custom images

If the ability to support custom images is selected then the additional resources are also deployed;

* Automation Account
* Storage Account
* Share Image Gallary
* Subnet for image building

The folder AzDO_ImageManagement will deploy the following Azure resources.

* Image Builder ARM templates, to build a custom Windows image.
* Runbooks for rebuilding images

Depending on the options chosen, it might be more desirable to deplicate the template and just use this as a base initializer or you could possibly urn into a situation where it is impossible to redeloy in the case of major functional loss.

## Build and Test

> ### Notes
>
> There has been no ability here to build a test / dev environment.  In a full production environment you probably want to deploy to a test pool first, especially for custom images, so development teams can test out any new toolset versions before promotion into production.

See the information at [Azure Image Builder Service](https://docs.microsoft.com/en-us/azure/virtual-machines/image-builder-overview) as an introduction.
