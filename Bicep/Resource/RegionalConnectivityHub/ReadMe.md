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
- PTS VPN
- Azure Firewall
- Express Route
- Azure Bastion
- Custom DNS Implementation

#### VNet Connected Services
```mermaid
	architecture-beta
		group hub(cloud)[Regional Hub]
		group dnsgroup(cloud)[DNS Resolver] in hub

		service network(server)[Virtual Network] in hub
		service bastion(server)[Azure Bastion] in hub
		service firewall(server)[Azure Firewall] in hub
		service route(server)[Azure Route Server] in hub
		service dns(server)[DNS Resolver] in dnsgroup
		service inbound(server)[Inbound Endpoint] in dnsgroup
		service outbound(server)[Outbound Endpoint] in dnsgroup

		junction vnet1 in hub
		junction vnet2 in hub
		junction dns1 in dnsgroup

		network:B -- T:vnet1
		vnet1:L --> R:firewall
		vnet1:B --> T:bastion
		vnet1:R -- L:vnet2
		vnet2:B --> T:route
		vnet2:R --> L:dns
		dns:B -- T:dns1
		dns1:R --> L:inbound
		dns1:B --> T:outbound

```
