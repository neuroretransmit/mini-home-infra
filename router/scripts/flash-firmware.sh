#!/bin/sh

ROUTER_HOST="god"
FIRMWARE_FNAME="netgear-r6400v2-webflash.bin"
ROUTER_FLASH_SCRIPT="router-flash-firmware.sh"
# ID for BitWarden entry
BW_SSH_KEY_PASS_ID="a75c2116-499d-411c-8354-ac1601335057"

# Check if BitWarden session is active
if [ -z ${BW_SESSION+x} ]; then
	echo "BitWarden session is unset. Please run 'bw login' and export \$BW_SESSION."
	exit 1
else
	echo "BitWarden session found..."
	# Sync latest if session found
	bw sync
fi

echo "Downloading latest firmware (FTP may throttle, be patient)..."
./download-latest.py 

if [ $? -ne 0 ]; then
	echo 'Failed to download latest firmware.' && exit 1
fi

echo "Copying firmware and remote script..."
sshpass \
	-P "Enter passphrase for key" \
	-p "$(bw get password $BW_SSH_KEY_PASS_ID)" \
	scp $FIRMWARE_FNAME $ROUTER_FLASH_SCRIPT "$ROUTER_HOST:/tmp" \
	|| echo 'Failed to copy firmware and remote script.' && exit 1

echo "Opening shell and executing remote script..."
sshpass \
	-P "Enter passphrase for key" \
	-p "$(bw get password $BW_SSH_KEY_PASS_ID)" ssh $ROUTER_HOST \
		"cd /tmp/ && sh router-flash-firmware.sh" \
		|| echo 'Failed to execute remote script.' && exit 1

echo "Done."
