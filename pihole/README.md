# pihole

## Hardware

I've been told this runs fine even on a Raspberry Pi Zero, however I'd recommend a 3 or better with at least a 16GB SD card.

## Setup

Install [rpi-imager](https://www.raspberrypi.org/downloads/) and install Raspberry Pi OS (lite) from `Choose OS->Rapberry Pi OS (other)->Raspberry Pi OS Lite (32-bit)` to your SD card.

On first boot, set your upstream DNS to your VPN provider's. Once at a shell, make sure the pihole is up to date.

`sudo apt update && sudo apt full-upgrade && reboot`

### Change Passwords/SSH Key

#### Passwords

SSH into the pihole and change password for user `pi`, then login as `root` and do the same.

#### SSH Key/Port

Use the [ssh-keygen.sh](../scripts/ssh-keygen.sh) script to generate an SSH key with preferred security settings. Set a password for the key as well. If you saved the key to a different location than `~/.ssh/id_rsa`, use the `-i ~/some/path` flag in addition to this command.

`ssh-copy-id pi@<IP-ADDRESS>`

Now SSH into the pihole and edit `/etc/ssh/sshd_config` and set the following lines.

```
Port 2222
PasswordAuthentication no
```

Finally, restart the SSH daemon.

`sudo systemctl restart sshd && logout`

For easy re-entry, create an entry in `~/.ssh/config`.

```
Host pihole
	User pi
	HostName <IP-ADDRESS>
	Port 2222
	IdentityFile <PATH TO PIHOLE SSH PRIVATE KEY>
```

Now you can simply `ssh pihole`.

### Adlists

```
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts 	
https://mirror1.malwaredomains.com/files/justdomains 	
https://github.com/kboghdady/youTube_ads_4_pi-hole/blob/master/youtubelist.txt 	
https://github.com/d43m0nhLInt3r/socialblocklists/blob/master/SmartTV/smarttvblocklist.txt 	
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt 	
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt 	
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt 	
https://dbl.oisd.nl/ 	
http://sysctl.org/cameleon/hosts 	
https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt 	
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://reddestdream.github.io/Projects/MinimalHosts/etc/MinimalHostsBlocker/minimalhosts 	
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/KADhosts/hosts 	
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.Spam/hosts 	
https://v.firebog.net/hosts/static/w3kbl.txt 	
https://v.firebog.net/hosts/BillStearns.txt 	
https://adaway.org/hosts.txt 	
https://v.firebog.net/hosts/AdguardDNS.txt 	
https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt 	
https://v.firebog.net/hosts/Easyprivacy.txt 	
https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt 	
https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt 	
https://www.malwaredomainlist.com/hostslist/hosts.txt 	
https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt 	
https://v.firebog.net/hosts/Prigent-Phishing.txt
https://github.com/chadmayfield/pihole-blocklists/raw/master/lists/pi_blocklist_porn_all.list 	
https://zerodot1.gitlab.io/CoinBlockerLists/hosts
```
