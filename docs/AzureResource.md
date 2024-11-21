# Azure Resources

Placing the resource extension at the end of the naming convention, which is different to the Microsoft best practice, means resources are grouped by name when viewing a complete list and not by the extension. I have found in practice this makes a big difference when viewing a large estate.

[AI + machine learning](#AI)\
[Analytics and IoT](#Analytics)\
[Compute and web](#user-content-compute-and-web)\
[Networking](#Networking)

<a id="AI" />

## AI + machine learning

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
AI Search | Microsoft.Search/searchServices | srch
Azure AI services | Microsoft.CognitiveServices/accounts (kind: AIServices) | ais
Azure AI Studio hub | Microsoft.MachineLearningServices/workspaces (kind: Hub) | hub
Azure AI Studio project | Microsoft.MachineLearningServices/workspaces (kind: Project) | proj
Azure AI Video Indexer | Microsoft.VideoIndexer/accounts | avi
Azure Machine Learning workspace | Microsoft.MachineLearningServices/workspaces | mlw
Azure OpenAI Service | Microsoft.CognitiveServices/accounts (kind: OpenAI) | oai
Bot service | Microsoft.BotService/botServices (kind: azurebot) | bot
Computer vision | Microsoft.CognitiveServices/accounts (kind: ComputerVision) | cv
Content moderator | Microsoft.CognitiveServices/accounts (kind: ContentModerator) | cm
Content safety | Microsoft.CognitiveServices/accounts (kind: ContentSafety) | cs
Custom vision (prediction) | Microsoft.CognitiveServices/accounts (kind: CustomVision.Prediction) | cstv
Custom vision (training) | Microsoft.CognitiveServices/accounts (kind: CustomVision.Training) | cstvt
Document intelligence | Microsoft.CognitiveServices/accounts (kind: FormRecognizer) | di
Face API | Microsoft.CognitiveServices/accounts (kind: Face) | face
Health Insights | Microsoft.CognitiveServices/accounts (kind: HealthInsights) | hi
Immersive reader | Microsoft.CognitiveServices/accounts (kind: ImmersiveReader) | ir
Language service | Microsoft.CognitiveServices/accounts (kind: TextAnalytics) | lang
Speech service | Microsoft.CognitiveServices/accounts (kind: SpeechServices) | spch
Translator | Microsoft.CognitiveServices/accounts (kind: TextTranslation) | trsl

<a id="Analytics" />

## Analytics and IoT

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Azure Analysis Services server | Microsoft.AnalysisServices/servers | as
Azure Databricks workspace | Microsoft.Databricks/workspaces | dbw
Azure Data Explorer cluster | Microsoft.Kusto/clusters | dec
Azure Data Explorer cluster database | Microsoft.Kusto/clusters/databases | dedb
Azure Data Factory | Microsoft.DataFactory/factories | adf
Azure Digital Twin instance | Microsoft.DigitalTwins/digitalTwinsInstances | dt
Azure Stream Analytics | Microsoft.StreamAnalytics/cluster | asa
Azure Synapse Analytics private link hub | Microsoft.Synapse/privateLinkHubs | synplh
Azure Synapse Analytics SQL Dedicated Pool | Microsoft.Synapse/workspaces/sqlPools | syndp
Azure Synapse Analytics Spark Pool | Microsoft.Synapse/workspaces/bigDataPools | synsp
Azure Synapse Analytics workspaces | Microsoft.Synapse/workspaces | synw
Data Lake Store account | Microsoft.DataLakeStore/accounts | dls
Data Lake Analytics account | Microsoft.DataLakeAnalytics/accounts | dla
Event Hubs namespace | Microsoft.EventHub/namespaces | evhns
Event hub | Microsoft.EventHub/namespaces/eventHubs | evh
Event Grid domain | Microsoft.EventGrid/domains | evgd
Event Grid subscriptions | Microsoft.EventGrid/eventSubscriptions | evgs
Event Grid topic | Microsoft.EventGrid/domains/topics | evgt
Event Grid system topic | Microsoft.EventGrid/systemTopics | egst
HDInsight - Hadoop cluster | Microsoft.HDInsight/clusters | hadoop
HDInsight - HBase cluster | Microsoft.HDInsight/clusters | hbase
HDInsight - Kafka cluster | Microsoft.HDInsight/clusters | kafka
HDInsight - Spark cluster | Microsoft.HDInsight/clusters | spark
HDInsight - Storm cluster | Microsoft.HDInsight/clusters | storm
HDInsight - ML Services cluster | Microsoft.HDInsight/clusters | mls
IoT hub | Microsoft.Devices/IotHubs | iot
Provisioning services | Microsoft.Devices/provisioningServices | provs
Provisioning services certificate | Microsoft.Devices/provisioningServices/certificates | pcert
Power BI Embedded | Microsoft.PowerBIDedicated/capacities | pbi
Time Series Insights environment | Microsoft.TimeSeriesInsights/environments | tsi

## General

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
API management service instance | Microsoft.ApiManagement/service | apim
Managed Identity | Microsoft.ManagedIdentity/userAssignedIdentities | id
Management group | Microsoft.Management/managementGroups | mg
Policy definition | Microsoft.Authorization/policyDefinitions | policy
Policy initiative | Microsoft.Authorization/policySetDefinitions | initiative
Resource group | Microsoft.Resources/resourceGroups| rg
Diagnostic Setting | Microsoft.*/*/providers/diagnosticSettings | diagset
Subscription | Microsoft.Subscription/aliases | sub

<a id="Networking" />

## Networking

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Application gateway | Microsoft.Network/applicationGateways | agw
Application security group (ASG) | Microsoft.Network/applicationSecurityGroups | asg
Bastion | Microsoft.Network/bastionHosts | bas
CDN profile | Microsoft.Cdn/profiles | cdnp
CDN endpoint | Microsoft.Cdn/profiles/endpoints | cdne
Connections | Microsoft.Network/connections | con
DNS private resolver | Microsoft.Network/dnsResolvers | dnspr
Public DNS zone | Microsoft.Network/dnsZones | \<DNS domain name>
Private DNS zone | Microsoft.Network/privateDnsZones | \<DNS domain name>
Firewall | Microsoft.Network/azureFirewalls | afw
ExpressRoute circuit | Microsoft.Network/expressRouteCircuits | erc
Front Door instance | Microsoft.Network/frontDoors | fd
Front Door firewall policy | Microsoft.Network/frontdoorWebApplicationFirewallPolicies | fdfp
Load balancer (internal) | Microsoft.Network/loadBalancers | lbi
Load balancer (external) | Microsoft.Network/loadBalancers | lbe
Load balancer rule | Microsoft.Network/loadBalancers/inboundNatRules | rule
Local network gateway | Microsoft.Network/localNetworkGateways | lgw
Network interface (NIC) | Microsoft.Network/networkInterfaces | nic
Network security group (NSG) | Microsoft.Network/networkSecurityGroups | nsg
Network security group (NSG) security rules | Microsoft.Network/networkSecurityGroups/securityRules | nsgsr
Network Watcher | Microsoft.Network/networkWatchers | nw
Private Link | "Microsoft.Network/privateLinkServices | pl
Public IP address | Microsoft.Network/publicIPAddresses | pip
Public IP address prefix | Microsoft.Network/publicIPPrefixes | ippre
Relay | Microsoft.Relay/namespaces | relay
Route filter | Microsoft.Network/routeFilters | rf
Route table | Microsoft.Network/routeTables | rt
Service endpoint | Microsoft.serviceEndPointPolicies | se
Traffic Manager profile | Microsoft.Network/trafficManagerProfiles | traf
User defined route (UDR) | Microsoft.Network/routeTables/routes | udr
Virtual network | Microsoft.Network/virtualNetworks | vnet
Virtual network peering | Microsoft.Network/virtualNetworks/virtualNetworkPeerings | peer
Virtual network subnet | Microsoft.Network/virtualNetworks/subnets | snet
Virtual WAN | Microsoft.Network/virtualWans | vwan
VPN Gateway | Microsoft.Network/vpnGateways | vpng
VPN connection | Microsoft.Network/vpnGateways/vpnConnections | cn
VPN site | Microsoft.Network/vpnGateways/vpnSites | st
Virtual network gateway | Microsoft.Network/virtualNetworkGateways | vgw
Web Application Firewall (WAF) policy | Microsoft.Network/firewallPolicies | waf
Web Application Firewall (WAF) policy rule group | Microsoft.Network/firewallPolicies/ruleGroups | wafrg

## Compute and Web

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
App Service environment | Microsoft.Web/sites | ase
App Service plan | Microsoft.Web/serverFarms | plan
Availability set | Microsoft.Compute/availabilitySets | avail
Azure Arc enabled server | Microsoft.HybridCompute/machines | arcs
Azure Arc enabled Kubernetes cluster | Microsoft.Kubernetes/connectedClusters | arck
Batch Account | Microsoft.Batch/batchAccounts | batch
Cloud service | Microsoft.Compute/cloudServices | cld
Disk encryption set | Microsoft.Compute/diskEncryptionSets | des
Function app | Microsoft.Web/sites | func
Gallery | Microsoft.Compute/galleries | gal
Managed disk (OS) | Microsoft.Compute/disks | osdisk
Managed disk (data) | Microsoft.Compute/disks | disk
Notification Hubs | Microsoft.NotificationHubs/namespaces/notificationHubs | ntf
Notification Hubs namespace | Microsoft.NotificationHubs/namespaces | ntfns
Snapshot | Microsoft.Compute/snapshots | snap
Static web app | Microsoft.Web/sites | stapp
Virtual machine | Microsoft.Compute/virtualMachines | vm
Virtual machine scale set | Microsoft.Compute/virtualMachineScaleSets | vmss
VM storage account | Microsoft.Storage/storageAccounts | stvm
Web app | Microsoft.Web/sites | app

## Containers

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
AKS cluster | Microsoft.ContainerService/managedClusters | aks
Container registry | Microsoft.ContainerRegistry/registries | cr
Container instance | Microsoft.ContainerInstance/containerGroups | ci
Service Fabric cluster | Microsoft.ServiceFabric/clusters | sf

## Databases

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Azure Cosmos DB database | Microsoft.DocumentDB/databaseAccounts/sqlDatabases | cosmos
Azure Cache for Redis instance | Microsoft.Cache/Redis | redis
Azure SQL Database server | Microsoft.Sql/servers | sql
Azure SQL database | Microsoft.Sql/servers/databases | sqldb
Azure Synapse Analytics | Microsoft.Synapse/workspaces | syn
Azure Synapse Analytics Workspaces | Microsoft.Synapse/workspaces | syn
Azure Synapse Analytics SQL Dedicated Pool | Microsoft.Synapse/workspaces/sqlPools | syndw
Azure Synapse Analytics Spark Pool | Microsoft.Synapse/workspaces/sqlPools | synspark
MySQL database | Microsoft.DBforMySQL/servers | mysql
PostgreSQL database | Microsoft.DBforPostgreSQL/servers | psql
SQL Server Stretch Database | Microsoft.Sql/servers/databases | sqlstrdb
SQL Elastic Pool | Microsoft.Sql/servers/elasticPools | sqlel
SQL Managed Instance | Microsoft.Sql/managedInstances | sqlmi
SQL Managed Instance database | Microsoft.Sql/managedInstances/databases | sqlmidb

## Storage

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Storage account | Microsoft.Storage/storageAccounts | st
Azure StorSimple | Microsoft.StorSimple/managers | ssimp

## AI and Machine Learning

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Azure Cognitive Search | Microsoft.Search/searchServices | srch
Azure Cognitive Services | Microsoft.CognitiveServices/accounts | cog
Azure Machine Learning workspace | Microsoft.MachineLearningServices/workspaces | mlw

## Analytics and IoT

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Azure Analysis Services server | Microsoft.AnalysisServices/servers | as
Azure Databricks workspace | Microsoft.Databricks/workspaces | dbw
Azure Stream Analytics | Microsoft.StreamAnalytics/cluster | asa
Azure Data Explorer cluster | Microsoft.Kusto/clusters | dec
Azure Data Explorer cluster database | Microsoft.Kusto/clusters/databases | dedb
Azure Data Factory | Microsoft.DataFactory/factories | adf
Data Lake Store account | Microsoft.DataLakeStore/accounts | dls
Data Lake Analytics account | Microsoft.DataLakeAnalytics/accounts | dla
Event Hubs namespace | Microsoft.EventHub/namespaces | evhns
Event hub | Microsoft.EventHub/namespaces/eventHubs | evh
Event Grid domain | Microsoft.EventGrid/domains | evgd
Event Grid topic | Microsoft.EventGrid/domains/topics | evgt
Event Grig subscription | Microsoft.EventGrid/eventSubscriptions | esub
HDInsight - Hadoop cluster | Microsoft.HDInsight/clusters | hadoop
HDInsight - HBase cluster | Microsoft.HDInsight/clusters | hbase
HDInsight - Kafka cluster | Microsoft.HDInsight/clusters | kafka
HDInsight - Spark cluster | Microsoft.HDInsight/clusters | spark
HDInsight - Storm cluster | Microsoft.HDInsight/clusters | storm
HDInsight - ML Services cluster | Microsoft.HDInsight/clusters | mls
IoT hub | Microsoft.Devices/IotHubs | iot
Provisioning services | Microsoft.Devices/provisioningServices | provs
Provisioning services certificate | Microsoft.Devices/provisioningServices/certificates | pcert
Power BI Embedded | Microsoft.PowerBIDedicated/capacities | pbi
Time Series Insights environment | Microsoft.TimeSeriesInsights/environments | tsi

## Developer tools

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
App Configuration store | Microsoft.AppConfiguration/configurationStores | appcs
Azure Static Web Apps | Microsoft.Web/sites | stap
SignalR | Microsoft.SignalRService/SignalR | sigr

## Integration

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Integration account | Microsoft.Logic/integrationAccounts | ia
Logic apps | Microsoft.Logic/workflows | logic
Service Bus | Microsoft.ServiceBus/namespaces | sb
Service Bus queue | Microsoft.ServiceBus/namespaces/queues | sbq
Service Bus topic | Microsoft.ServiceBus/namespaces/topics | sbt

## Management and governance

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Automation account | Microsoft.Automation/automationAccounts | aa
Application Insights | Microsoft.Insights/components | appi
Azure Monitor action group | Microsoft.Insights/actionGroups | ag
Azure Purview instance | Microsoft.Purview/accounts | pview
Blueprint | Microsoft.Blueprint/blueprints | bp
Blueprint assignment | Microsoft.Blueprint/blueprints/artifacts | bpa
Key vault | Microsoft.KeyVault/vaults | kv
Log Analytics workspace | Microsoft.OperationalInsights/workspaces | log
Metric Alerts | Microsoft.Insights/metricAlerts | ma
Web Availability Request | Microsoft.Insights/webtests | wt

## Migration

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Azure Migrate project | Microsoft.Migrate/assessmentProjects | migr
Database Migration Service instance | Microsoft.DataMigration/services | dms
Recovery Services vault | Microsoft.RecoveryServices/vaults | rsv

## Deprecated product names

Resource | Resource provider namespace | Abbreviation
-------- | --------------------------- | ------------
Azure SQL Data Warehouse | Microsoft.Sql/servers | sqldw
