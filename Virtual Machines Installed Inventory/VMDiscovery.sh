#!/bin/sh

#  VMDiscovery.sh
#  
#
#  Created by Bennett Norton on 3/31/16.
#

#################################################################
###   Part 1 - Create an Output File of VMs on the Machine    ###
#################################################################

# Set the Output file path, do not change
outputFile="/Library/Application Support/LANDesk/Data/ldscan.core.data.plist"

# Create array of VM's based on file type
# sed is deleting all VMs with the name importer, template, vadk as these are default objects
IFS=$'\n'
vmArray=( $( find / \( -name "*.vmx" -o -name "*.pvm" -o -name "*.vdi" -o -name "*.vhd" \) -exec basename {} \; | sed '/importer/d' | sed '/template/d' | sed '/vadk/d' ) )
unset IFS

# Detect if the array is empty.  If it is, do nothing.  Otherwise, create the output file.
if [ ${#vmArray[@]} -eq 0 ]
then
    echo "No VM's Found"
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
# Write the array of virtual machines to the plist
    for i in "${vmArray[@]}"
        do
            Counter=$((Counter+1))
            echo "<key>Virtual Machines - Virtual Machine - (Number:$Counter) - Number</key>" >> "$outputFile"
            echo "<integer>$Counter</integer>" >> "$outputFile"
            echo "<key>Virtual Machines - Virtual Machine - (Number:$Counter) - Name </key>"  >> "$outputFile"
            echo "<string>$i</string>" >> "$outputFile"
            echo "<key>Virtual Machines - Virtual Machine - (Number:$Counter) - Workflow Status ID</key>" >> "$outputFile"
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
#/Library/Application\ Support/LANDesk/bin/ldiscan -e -s

