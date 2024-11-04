# Introduction

This Bicep template deploys a Azure application app service and associated application insights instance.
The application insights instance can be linked to an existing log analytics workspace or to a pre existing instance.

## Parameters
```
	@description('The location of the resources created, excluding 'Global', defaults to the resource group location.')
	param location string = resourceGroup().location

	@description('The environment tag to provide unique resources between test / production and ephemeral environments.')
	param environment string = 'ObjInt'

	@description('The external Log Analytics Workspace to connect to, if blank a local workspace will be created, defaults to blank.')
	param logAnalyticsWorkspaceResourceId string = ''
```

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdrewkg%2FAzure%2Ffeature%2FAppService%2FARM%2FResource%2FAppServiceWithMSIAppInsights%2FazureDeploy.json)

[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fdrewkg%2FAzure%2Fmain%2FARM%2FResource%2FAppServiceWithMSIAppInsights%2FazureDeploy.json)

#### With Dedicated Log Analytics Workspace
```mermaid
	architecture-beta
		group api(cloud)[Web App]

		service internet(internet)
		service asp(server)[App Service Plan] in api
		service server(server)[Web App] in api
		service appi(server)[Application Insights] in api
		service dashboard(server)[AppInsights Dashboard] in api
		service law(server)[Log Analytics Workspace] in api

		internet:B --> T:server

		asp:L <-- R:server
		server:B --> T:appi
		appi:R -- L:dashboard
		appi:B --> T:law
```

#### With Shared Log Analytics Workspace
```mermaid
	architecture-beta
		group api(cloud)[Web App]
		group platform(cloud)[Platform]

		service internet(cloud)
		service asp(server)[App Service Plan] in api
		service server(server)[Web App] in api
		service appi(server)[Application Insights] in api
		service dashboard(server)[AppInsights Dashboard] in api
		service law(server)[Log Analytics Workspace] in platform

		internet:B --> T:server

		asp:L <-- R:server
		server:B --> T:appi
		appi:R -- L:dashboard
		appi:B --> T:law
```
## Notes
These Bicep templates are meant as a starter resource, to be modified to your own requirements.
