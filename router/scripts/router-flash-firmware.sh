#!/bin/sh

FIRMWARE_FNAME="netgear-r6400v2-webflash.bin"

cd /tmp/

if ! test -f $FIRMWARE_FNAME;
  then echo 'Unable to find $FIRMWARE_FNAME'
  exit 1
else
  write $FIRMWARE_FNAME linux || echo 'ERROR: write command failed.' && exit 1
  echo "Firmware successfully flashed."
  echo "Rebooting..."
  reboot
fi
