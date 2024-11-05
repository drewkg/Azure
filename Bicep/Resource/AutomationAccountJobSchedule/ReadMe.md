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
