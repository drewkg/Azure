# Introduction

The azureDeploy.json in this folder deomstrates that is is now possible to deploy an Automation Account, Runbook, Schedule and Jobschedule in a repeatable manner.

There are some limitations with this approach, due to the way that ARM handles deletions, you cannot replace the JobSchedule and additionally if the link is manually removed then you must change the key to the new Guid function.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdrewkg%2FAzure%2Fmain%2FARM%2FResource%2FAutomationAccountJobSchedule%2FazureDeploy.json)

[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fdrewkg%2FAzure%2Fmain%2FARM%2FResource%2FAutomationAccountJobSchedule%2FazureDeploy.json)
