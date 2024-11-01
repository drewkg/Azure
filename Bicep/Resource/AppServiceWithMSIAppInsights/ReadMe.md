# Read Me

## Introduction

This Bicep template deploys a an Azure application app service and associated application insights instance.


## Notes

These Bicep templates are meant as a starter resource, to be modified to your own requirements.

```mermaid
	architecture-beta
    group api(cloud)[API]

    service db(database)[Database] in api
    service disk1(disk)[Storage] in api
    service disk2(disk)[Storage] in api
    service server(server)[Server] in api

    db:L -- R:server
    disk1:T -- B:server
    disk2:T -- B:db
```

```mermaid
  info
```
