# Read Me

## Introduction

Taken from the Microsoft Enterprise Scale Cloud Adoption Framework these templates attempt to provide co-operating ARM tempaltes to deploy the first the basic subscriptions, this is

- Management

The management subscription contains the core log analytics workspace, a linked automation account and common dashboards.

#### Platform Log Analytics
```mermaid
	architecture-beta
		group solutions(cloud)[Solutions]
		group automations(cloud)[Automations]

		service loganalytics(server)[Log Analytics Workspace]
		service lawdiagnostics(server)[Diagnostic Settings]
		service automationaccount(server)[Automation Account]
		service aadiagnostics(server)[DiagnosticSettings]

		service azureactivity(server)[Azure Activity] in solutions
		service azureautomation(server)[Azure Automation] in solutions
		service keyvault(server)[KeyVault] in solutions
		service SecurityCenter(server)[Security Centre] in solutions

		service runbook(server)[Runbook] in automations
		service schedule(server)[Schedule] in automations
		service link(server)[Job Schedule Link] in automations

		loganalytics:L <--> R:automationaccount
		loganalytics:R -- L:lawdiagnostics
		automationaccount:L -- R:aadiagnostics

		loganalytics:B -- T:azureactivity{group}

		automationaccount:B -- T:runbook{group}
		schedule:R -- L:link
		runbook:L -- R:link
```
