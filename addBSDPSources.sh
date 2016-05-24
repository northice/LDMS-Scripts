#!/bin/bash
set -o nounset
addresses_to_add=(192.168.29.11 192.168.29.12 192.168.29.13 192.168.29.15)

	# Run csrutil on each entry
for address in "${addresses_to_add[@]}"; do
	echo "Adding $address to bsdp whitelist"
 	csrutil netboot add "$address"
done

exit 0
