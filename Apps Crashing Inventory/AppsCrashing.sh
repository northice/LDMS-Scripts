#!/bin/sh

#  Crash Log Discovery.sh
#  
#
#  Created by Bennett Norton on 3/31/16.
#

#################################################################
###   Part 1 - Output File of Crash Logs on the Machine       ###
#################################################################

# Set the Output file path, do not change
outputFile="/Library/Application Support/LANDesk/Data/ldscan.core.data.plist"

# Create array of crash logs based on file type
# sed is deleting all VMs with the name importer, template, vadk as these are default objects
IFS=$'\n'
systemAppsCrashingArray=( $( find /Library/Logs/DiagnosticReports \( -name "*.crash" -mtime -30 \) -exec basename {} \; ) )
userAppsCrashingArray=( $( find ~/Library/Logs/DiagnosticReports \( -name "*.crash" -mtime -30 \) -exec basename {} \; ) )
unset IFS

# Detect if the arrays are empty.  If it is, do nothing.  Otherwise, create the output file.
if [ ${#systemAppsCrashingArray[@]} -eq 0 ] || [ ${#userAppsCrashingArray[@]} -eq 0 ]
then
    echo "No Crash Logs Found"
else

# Detect if there is an existing plist file, make a backup and delete the original to ensure clean data is sent up
# If you have multiple different custom scripts, you may not want to delete this plist file
    if [ -e "$outputFile" ]
    then
        cp "$outputFile" "$outputFile.old"
        rm "$outputFile"
    fi

# specifying the plist structure
# you won’t need to change any of these options, just copy them into your script
    echo '<?xml version="1.0" encoding="UTF-8"?>'  >> "$outputFile"
    echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> "$outputFile"
    echo '<plist version="1.0">' >> "$outputFile"
    echo "<dict>" >> "$outputFile"
# Write the array of crashed apps to the plist
    for i in "${userAppsCrashingArray[@]}"
        do
            #Counter=$((Counter+1))
            echo "<key>Diagnostic Data - Application Errors - (Application Name:$i) - Application Name</key>" >> "$outputFile"
            echo "<string>$i</string>" >> "$outputFile"
            echo "<key>Diagnostic Data - Application Errors - (Application Name:$i) - Workflow Status ID</key>" >> "$outputFile"
            echo "<integer>0</integer>" >> "$outputFile"

    done

    for i in "${systemAppsCrashingArray[@]}"
        do
            #Counter=$((Counter+1))
            echo "<key>Diagnostic Data - Application Errors - (Application Name:$i) - Application Name</key>" >> "$outputFile"
            echo "<string>$i</string>" >> "$outputFile"
            echo "<key>Diagnostic Data - Application Errors - (Application Name:$i) - Workflow Status ID</key>" >> "$outputFile"
            echo "<integer>0</integer>" >> "$outputFile"

    done
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

