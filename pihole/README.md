# pihole

## Hardware

I've been told this runs fine even on a Raspberry Pi Zero, however I'd recommend a 3 or better with at least a 16GB SD card.

## Setup

Install [rpi-imager](https://www.raspberrypi.org/downloads/) and install
Raspberry Pi OS (lite) from `Choose OS->Rapberry Pi OS (other)->Raspberry Pi OS Lite (32-bit)` to your SD card.

Once at a shell, make sure the pihole is up to date.

`sudo apt update && sudo apt full-upgrade && sudo apt install vim && sudo reboot`

### Change Passwords/SSH Key

#### Passwords

SSH into the pihole and change password for user `pi`, then login as `root` and
do the same.

#### SSH Key/Port

Use the [ssh-keygen.sh](../scripts/ssh-keygen.sh) script to generate an SSH key
with preferred security settings (ed25519 instead of RSA). Set a password for
the key as well if you are extra paranoid like myself. If you saved the key to a
different location than `~/.ssh/id_rsa`, use the `-i ~/some/path` flag in
addition to this command.

`ssh-copy-id pi@<IP-ADDRESS>`

Now SSH into the pihole and edit `/etc/ssh/sshd_config` and set the following
lines, port is optional - I like to stick common services on non-standard ports
on a really high or ephemeral port.

```
Port 22222
PasswordAuthentication no
```

Finally, restart the SSH daemon.

`sudo systemctl restart sshd && logout`

For easy re-entry, create an entry in `~/.ssh/config` on your local machine. You can just `ssh <Host field>` without specifying key.

```
Host pihole
	User pi
	HostName <IP-ADDRESS>
	Port 22222
	IdentityFile <PATH TO PIHOLE SSH PRIVATE KEY>
```

Now you can simply `ssh pihole`.

### Install Pi-hole

Make sure to copy admin password from the last screen

```bash
curl -sSL https://install.pi-hole.net | bash
```

Set your upstream DNS to your VPN provider's or CloudFlare's (1.1.1.1 and 1.0.0.1)

#### Modify Admin Password (optional, will be random on initial generation)

```bash
pihole -a -p
```

### Adlists

```
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts 	
https://mirror1.malwaredomains.com/files/justdomains 	
https://raw.githubusercontent.com/kboghdady/youTube_ads_4_pi-hole/master/huluads.txt
https://raw.githubusercontent.com/kboghdady/youTube_ads_4_pi-hole/master/youtubelist.txt
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

### Whitelist RegEx

In the admin page (http://pi.hole/admin) or under your IP if your DNS isn't
pointing to the Pi-hole yet, navigate to `Whitelist->Regex filter` and add the
following to unblock servers for YouTube, the adlist catches some valid servers.

`r[0-9]---sn-[a-z0-9]{8}\.googlevideo.com`

### Use DNSSEC

`Settings->DNS` and check use DNSSEC
