#!/bin/bash

#################################################################
###   Part 1 - Create an Output File with the HD SMART Status ###
#################################################################

# Create the Output file with the appropriate XML structure so the inventory scanner can read the data

# Set the Output file path, do not change
outputFile="/Library/Application Support/LANDesk/Data/ldscan.core.data.plist"

# Detect if there is an existing plist file, make a backup and delete the original to ensure clean data is sent up
if [ -e "$outputFile" ]
then
cp "$outputFile" "$outputFile.old"
rm "$outputFile"
fi

# specifying the plist structure and telling
echo '<?xml version="1.0" encoding="UTF-8"?>'  >> "$outputFile"
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> "$outputFile"
echo '<plist version="1.0">' >> "$outputFile"
echo "<dict>" >> "$outputFile"

# command to list all of the drives, capture the status and insert the status as XML output in the output file
devices=( $(diskutil list  | egrep "^/" | grep "physical" | sed 's/ .*//') )

for hardDrive in "${devices[@]}"
do
# create the variables for the different attributes
    IFS=$'\n'
    deviceIdentifier=( $(diskutil info $hardDrive | grep "Device Identifier" | sed 's/disk//'| awk '{print $3}' ) )
    deviceNode=( $(diskutil info $hardDrive | grep "Device Node" | awk '{print $3}' ) )
    deviceName=( $(diskutil info $hardDrive | grep "Device / Media Name" | awk '{print $5 " " $6 " " $7 " " $8 " " $9 " " $10 " "}') )
    SMARTStatus=( $(diskutil info $hardDrive | grep "SMART" | awk '{print $3}' ) )
    deviceLocation=( $(diskutil info $hardDrive | grep "Device Location" | awk '{print $3}' ) )
    removableMedia=( $(diskutil info $hardDrive | grep "Removable Media" | awk '{print $3}' ) )
    solidState=( $(diskutil info $hardDrive | grep "Solid State" | awk '{print $3}' ) )
    unset IFS

    Counter=$((Counter+1))

    echo "<key>Mass Storage - SMART Status - (Device Identifier:$deviceIdentifier) - Device Name</key>" >> "$outputFile"
    echo "<string>$deviceName</string>" >> "$outputFile"

    echo "<key>Mass Storage - SMART Status - (Device Identifier:$deviceIdentifier) - SMART Status</key>" >> "$outputFile"
    echo "<string>$SMARTStatus</string>" >> "$outputFile"

    echo "<key>Mass Storage - SMART Status - (Device Identifier:$deviceIdentifier) - Device Identifier</key>" >> "$outputFile"
    echo "<string>$deviceIdentifier</string>" >> "$outputFile"

    echo "<key>Mass Storage - SMART Status - (Device Identifier:$deviceIdentifier) - Device Node</key>" >> "$outputFile"
    echo "<string>$deviceNode</string>" >> "$outputFile"

    echo "<key>Mass Storage - SMART Status - (Device Identifier:$deviceIdentifier) - Device Location</key>" >> "$outputFile"
    echo "<string>$deviceLocation</string>" >> "$outputFile"

    echo "<key>Mass Storage - SMART Status - (Device Identifier:$deviceIdentifier) - Removable Media</key>" >> "$outputFile"
    echo "<string>$removableMedia</string>" >> "$outputFile"

    echo "<key>Mass Storage - SMART Status - (Device Identifier:$deviceIdentifier) - Solid State</key>" >> "$outputFile"
    echo "<string>$solidState</string>" >> "$outputFile"

    echo "<key>Mass Storage - SMART Status - (Device Identifier:$deviceIdentifier) - Workflow Status ID</key>" >> "$outputFile"
    echo "<integer>0</integer>" >> "$outputFile"

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
