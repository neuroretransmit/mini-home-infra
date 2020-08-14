# Router

## Scripts

### [flash-firmware.sh](flash-firmware.sh)

This script is the cradle for all scripts within this folder.

1. Pull down the latest DD-WRT release from FTP (`download-latest.py`)
2. SCP the downloaded binary and the remote script [router-flash-firmware.sh](router-flash-firmware.sh) to `/tmp/` on the router.
3. SSH into the router and execute the remote script.

### [download-latest.py](download-latest.py)

Crawls FTP and downloads the latest firmware binary.

### [router-flash-firmware.sh](router-flash-firmware.sh)

This is the remote execution script for actually flashing the image on the router.

1. Flash binary
2. Reboot

## Setup

### TODO SSH/Keys

### IPV6

Path | Field | Value
--- | --- | ---
Setup->IPV6 | IPv6 | Disable

### UPnP

Path | Field | Value
--- | --- | ---
NAT/QoS->UPnP | UPnP Service | Disable

### VPN

Set router DNS to VPN DNS and connect to VPN:

Path | Field | Value
--- | --- | ---
Setup->Basic Setup->Network Setup->Network Address Server Settings (DHCP) | Static DNS [0-3] | VPN Provider DNS
Setup->Basic Setup->Network Setup->Network Address Server Settings (DHCP) | Use DNSMasq for DNS | Checked
Setup->Basic Setup->Network Setup->Network Address Server Settings (DHCP) | DHCP Authoritative | Checked
Services->VPN->OpenVPN Client | Start OpenVPN Client | Enable
Services->VPN->OpenVPN Client | Server IP/Name | VPN server IP
Services->VPN->OpenVPN Client | Port | 1194 for UDP 443 for TCP
Services->VPN->OpenVPN Client | Tunnel Device | TUN
Services->VPN->OpenVPN Client | Encryption Cipher | VPN specified
Services->VPN->OpenVPN Client | Hash Algorithm | VPN specified
Services->VPN->OpenVPN Client | User Pass Authentication | Enable
Services->VPN->OpenVPN Client->User Pass Authentication | Username | VPN username
Services->VPN->OpenVPN Client->User Pass Authentication | Password | VPN password
Services->VPN->OpenVPN Client | TLS Cipher | VPN specified
Services->VPN->OpenVPN Client | LZO Compression | Disable
Services->VPN->OpenVPN Client | NAT | Enable
Services->VPN->OpenVPN Client | TLS Key | VPN specified
Services->VPN->OpenVPN Client | Additional Config | VPN specified
Services->VPN->OpenVPN Client | Policy based Routing | IPs you want on VPN
Services->VPN->OpenVPN Client | CA Cert | VPN specified

#### Killswitch for dropped VPN connection

Add the following to commands, replacing each IP with the IPs you used in policy-based routing in OpenVPN's config and click `Save Firewall`.

```
# OpenVPN client policy-based routing killswitch for dropped VPN connection
# to disallow traffic without VPN.
iptables -I FORWARD -s 192.168.1.146 -o $(nvram get wan_iface) -j DROP
iptables -I FORWARD -s 192.168.1.106 -o $(nvram get wan_iface) -j DROP
iptables -I FORWARD -s 192.168.1.117 -o $(nvram get wan_iface) -j DROP
iptables -I FORWARD -s 192.168.1.105 -o $(nvram get wan_iface) -j DROP
iptables -I FORWARD -s 192.168.1.139 -o $(nvram get wan_iface) -j DROP
iptables -I FORWARD -s 192.168.1.132 -o $(nvram get wan_iface) -j DROP
```

## Pi-hole (optional)

Path | Field | Value
--- | --- | ---
Services->Services->Dnsmasq | Additional Dnsmasq Options | dhcp-option=6,*\<pi ip here\>*
