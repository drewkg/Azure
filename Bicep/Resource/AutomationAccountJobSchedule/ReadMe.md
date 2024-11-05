# Introduction
The azureDeploy.bicep in this folder deomstrates that is is now possible to deploy an Automation Account, Runbook, Schedule and Jobschedule in a repeatable manner.

#### Automation Account, Runbook and Schedule
```mermaid
---
title: Automation Account, Runbook and Schedule
---
	architecture-beta
		group automation(cloud)[Management]

		service server(server)[Automation Account] in automation
		service runbook(server)[Runbook] in automation
		service schedule(server)[Schedule] in automation
		service link(server)[Job Schedule Link] in automation

		server:B -- T:runbook
		server:R -- L:schedule
		runbook:R --> L:link
		schedule:B --> T:link
```
##### Notes
- The Schedule Link name has to be a guid, and cannot be reused if its removed
- Due to way ARM handles deletions (post deployment), the link cannot be removed and created in the same operation.
