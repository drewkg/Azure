# Introduction

The azureDeploy.bicep in this folder deomstrates that is is now possible to deploy an Automation Account, Runbook, Schedule and Jobschedule in a repeatable manner.

There are some limitations with this approach, due to the way that ARM handles deletions, you cannot replace the JobSchedule and additionally if the link is manually removed then you must change the key to the new Guid function.
