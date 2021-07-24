# Read Me

## Introduction

The template provides a set of Azure policies and a policy initiative, for the configuration of Azure Secure Center against a subscription.  The template is deployed at Management Group level, there are no parameters, and then you have to assign the Azure Policy Initiative to the Management Group.  Any subscriptions then moved into that management group will have the Policy applied automatically.  For any existing subscriptions you will need to manually remediate to resolve compliance issues.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdrewkg%2FAzure%2Ffeature%2FSecurityCenter%2FARM%2FPolicy%2FSecurityCenter%2FazureDeploy.json)
