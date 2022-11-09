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

* VNet for hosted the ScaleSet, and providing connectivity.
* Azure Virtual Macine Scale Set, this should be one per pool in Azure DevOps.
* Virtal Machine Images, if none of the Azure market palce images fulfil your requirements
* Azure Share Image Gallery, for hosting any custom images.

## Management

Some areas of consideration to take into account

* Ability to recreate the Virtual Machine Images, at least to apply any latest patches.
* Versioning of Agent Pools, this allows the solution to take into account different tool sets going forward.

## Getting Started

See the information at [Azure Image Builder Service](https://docs.microsoft.com/en-us/azure/virtual-machines/image-builder-overview) as an introduction.

## Build and Test
