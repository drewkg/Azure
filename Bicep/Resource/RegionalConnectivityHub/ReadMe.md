# Introduction
Depending on your requirements there are two way to achieve a hub and spoke network design within Azure, either using the newer vWAN capability or a more traditional hub and spoke impelementation.  Your choice will depend a lot on the rexperience within your company and the caoabilities you desire.

Some reasons for selecting the more traditional approach include
- private DNS integration (still possible with vWAN with alternative design)
- Azure Bastion
- Express Route Global Reach
- Route Server

## Services on Offer
Some of the services offered in a hub may include
- STS VPN
- Azure Firewall
- Express Route
- Azure Bastion
- Custom DNS Implementation

#### Platform Log Analytics
```mermaid
	architecture-beta
		group management(cloud)[Managment]
		group solutions(cloud)[Solutions] in management
		group automations(cloud)[Automations] in management

		service loganalytics(server)[Log Analytics Workspace] in management
		service lawdiagnostics(server)[Diagnostic Settings] in management
		service automationaccount(server)[Automation Account] in management
		service aadiagnostics(server)[Diagnostic Settings] in management

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

		loganalytics:B --> T:azureactivity{group}

		automationaccount:B --> T:runbook{group}
		schedule:R -- L:link
		runbook:L -- R:link
```
