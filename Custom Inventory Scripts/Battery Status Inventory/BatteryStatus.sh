#!/bin/sh

#  BatteryStatus.sh
#  
#
#  Created by Bennett Norton on 3/30/16.
#
#################################################################
###   Part 1 - Create an Output File for the Battery Status   ###
#################################################################

# Set the Output file path, do not change
outputFile="/Library/Application Support/LANDesk/Data/ldscan.core.data.plist"


# Detect if there is an existing plist file, make a backup and delete the original to ensure clean data is sent up
# If you have multiple different custom scripts, you may not want to delete this plist file
if [ -e "$outputFile" ]
then
cp "$outputFile" "$outputFile.old"
rm "$outputFile"
fi

# Obtain the data related to the battery
hasBattery=( $( system_profiler SPPowerDataType | grep "Battery Installed:" | awk '{print $3}') )

if [ "$hasBattery" == "Yes" ]
then
# Collect the variables
    batteryCondition=( $( system_profiler SPPowerDataType | grep "Condition:" | awk '{print $2}') )
    manufacturerName=( $( system_profiler SPPowerDataType | grep "Manufacturer:" | awk '{print $2}') )
    deviceName=( $( system_profiler SPPowerDataType | grep "Device Name:" | awk '{print $3}') )
    serialNumber=( $( system_profiler SPPowerDataType | grep "Serial Number:" | awk '{print $3}') )
    cycleCount=( $( system_profiler SPPowerDataType | grep "Cycle Count:" | awk '{print $3}') )
    currentMA=( $( system_profiler SPPowerDataType | grep "Charge Remaining (mAh):" | awk '{print $4}') )


# specifying the plist structure
# you won’t need to change any of these options, just copy them into your script
    echo '<?xml version="1.0" encoding="UTF-8"?>'  >> "$outputFile"
    echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> "$outputFile"
    echo '<plist version="1.0">' >> "$outputFile"
    echo "<dict>" >> "$outputFile"

# Write the names and values to the plist file
    echo "<key> Battery - Device Name</key>"  >> "$outputFile"
    echo "<string>$deviceName</string>" >> "$outputFile"
    echo "<key> Battery - Battery Condition</key>"  >> "$outputFile"
    echo "<string>$batteryCondition</string>" >> "$outputFile"
    echo "<key> Battery - Manufacturer</key>"  >> "$outputFile"
    echo "<string>$manufacturerName</string>" >> "$outputFile"
    echo "<key> Battery - Serial Number</key>"  >> "$outputFile"
    echo "<string>$serialNumber</string>" >> "$outputFile"
    echo "<key> Battery - Cycle Count</key>"  >> "$outputFile"
    echo "<string>$cycleCount</string>" >> "$outputFile"
    echo "<key> Battery - Current (mA)</key>"  >> "$outputFile"
    echo "<string>$currentMA</string>" >> "$outputFile"
    echo "<key> Battery - Workflow Status ID</key>"  >> "$outputFile"
    echo "<integer>0</integer>" >> "$outputFile"

# close out the plist structure
    echo "</dict>" >> "$outputFile"
    echo "</plist>" >> "$outputFile"
fi

#################################################################
###   Part 2 - Force an Inventory Scan to Run                 ###
#################################################################

# -e forces a hardware and software scan and -s forces a sync
# this step is optional
/Library/Application\ Support/LANDesk/bin/ldiscan -e -s






