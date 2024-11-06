# Introduction

The azureDeploy.json in this folder deomstrates that is is now possible to deploy an Automation Account, Runbook, Schedule and Jobschedule in a repeatable manner.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdrewkg%2FAzure%2Fmain%2FARM%2FResource%2FAutomationAccountJobSchedule%2FazureDeploy.json)

[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fdrewkg%2FAzure%2Fmain%2FARM%2FResource%2FAutomationAccountJobSchedule%2FazureDeploy.json)

# Introduction
The azureDeploy.bicep in this folder deomstrates that is is now possible to deploy an Automation Account, Runbook, Schedule and Jobschedule in a repeatable manner.

#### Automation Account, Runbook and Schedule
```mermaid
	architecture-beta
		group automation(cloud)[Management]

		service automationaccount(server)[Automation Account] in automation
		service runbook(server)[Runbook] in automation
		service schedule(server)[Schedule] in automation
		service link(server)[Job Schedule Link] in automation

		junction junctionRight in automation

		automationaccount:B -- T:junctionRight

		junctionRight:L -- B:runbook
		junctionRight:R -- B:schedule

		runbook:R --> L:link
		schedule:L --> R:link
```
##### Notes
- The Schedule Link name has to be a GUID (UUID), and cannot be reused if its removed
- Due to way ARM handles deletions (post deployment), the link cannot be removed and created in the same operation.
