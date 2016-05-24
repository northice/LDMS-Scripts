#!/bin/bash

##################################################################
###   Part 1 - Create an Output File with the Package Receipts ###
##################################################################

# Create the Output file with the appropriate XML structure so the inventory scanner can read the data

# Set the Output file path, do not change
outputFile="/Library/Application Support/LANDesk/Data/ldscan.core.data.plist"

# Detect if there is an existing plist file, make a backup and delete the original to ensure clean data is sent up
if [ -e "$outputFile" ]
then
cp "$outputFile" "$outputFile.old"
rm "$outputFile"
fi

# specifying the plist structure
echo '<?xml version="1.0" encoding="UTF-8"?>'  >> "$outputFile"
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> "$outputFile"
echo '<plist version="1.0">' >> "$outputFile"
echo "<dict>" >> "$outputFile"

packageReceipts=( $( pkgutil --pkgs ) )

for receipt in "${packageReceipts[@]}"
do
# create the variables for the different attributes
    IFS=$'\n'
    packageID=( $(pkgutil --pkg-info $receipt | grep "package-id" | sed 's/package-id: //' ) )
    version=( $(pkgutil --pkg-info $receipt | grep "version" | sed 's/version: //' ) )
    volume=( $(pkgutil --pkg-info $receipt | grep "volume" | sed 's/volume: //' ) )
    location=( $(pkgutil --pkg-info $receipt | grep "location" | sed 's/location: //' ) )
    installTime=( $(pkgutil --pkg-info $receipt | grep "install-time" | sed 's/install-time: //' ) )
    unset IFS


    echo "<key>Software - Package Receipt - (Package ID:$packageID) - Package ID</key>" >> "$outputFile"
    echo "<string>$packageID</string>" >> "$outputFile"

    echo "<key>Software - Package Receipt - (Package ID:$packageID) - Version</key>" >> "$outputFile"
    echo "<string>$version</string>" >> "$outputFile"

    echo "<key>Software - Package Receipt - (Package ID:$packageID) - Volume</key>" >> "$outputFile"
    echo "<string>$volume</string>" >> "$outputFile"

    echo "<key>Software - Package Receipt - (Package ID:$packageID) - Location</key>" >> "$outputFile"
    echo "<string>$location</string>" >> "$outputFile"

    echo "<key>Software - Package Receipt - (Package ID:$packageID) - Install Time</key>" >> "$outputFile"
    echo "<string>$installTime</string>" >> "$outputFile"

done
  	
# close the plist file
echo "</dict>" >> "$outputFile"
echo "</plist>" >> "$outputFile"

#################################################################
###   Part 2 - Force an Inventory Scan to Run                 ###
#################################################################

# -e forces a hardware and software scan and -s forces a sync
# this step is optional
/Library/Application\ Support/LANDesk/bin/ldiscan -e -s
