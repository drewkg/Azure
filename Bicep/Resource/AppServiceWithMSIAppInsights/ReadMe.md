# Introduction

This Bicep template deploys a an Azure application app service and associated application insights instance.



```mermaid
	architecture-beta
    group api(cloud)[Web App]

    service internet(cloud)
    service db(database)[Database] in api
    service disk2(disk)[Storage] in api
    service server(server)[Web App] in api
		service appi(server)[Application Insights] in api
		service law(server)[Log Analytics Workspace] in api

		internet:B --> T:server

    db:L -- R:server
    disk2:T -- B:db
		server:B --> T:appi
		appi:B --> T:law
```

```mermaid
	architecture-beta
    group api(cloud)[Web App]
		group platform(cloud)[Platform Service]

    service internet(cloud)
    service db(database)[Database] in api
    service disk2(disk)[Storage] in api
    service server(server)[Web App] in api
		service appi(server)[Application Insights] in api
		service law(server)[Log Analytics Workspace] in platform

		internet:B --> T:server

    db:L -- R:server
    disk2:T -- B:db
		server:B --> T:appi
		appi:B --> T:law
```
## Notes

These Bicep templates are meant as a starter resource, to be modified to your own requirements.
