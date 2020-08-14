#!/bin/sh

# ID for BitWarden entry
BW_ID="63f072c1-8b60-4d22-8f50-ac1601879904"

# Check if BitWarden session is active
if [ -z ${BW_SESSION+x} ]; then
	echo "BitWarden session is unset. Please run 'bw login' and export \$BW_SESSION."
	exit 1
else
	echo "BitWarden session found..."
	# Sync latest if session found
	bw sync
fi

FILES="$(find . -name nvrambak**.bin)"

if [ -n "$FILES" ]; then
	for f in "$FILES"; do
		echo "Encrypting $f to $f.enc..."
		openssl aes-256-cbc -pbkdf2 -in "$f" -out "$f.enc" -pass "pass:$(bw get password "$BW_ID")"
	done

	git add -A
fi
