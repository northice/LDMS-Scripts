#!/bin/sh

#  Time Machine Backups.sh
#  
#
#  Created by Bennett Norton on 4/14/16.
#

#################################################################
###   Part 1 - Output File of Time Machine Backups            ###
#################################################################

# Set the Output file path, do not change
outputFile="/Library/Application Support/LANDesk/Data/ldscan.core.data.plist"

# Create variable to see if backups are enabled
autoBackup=( $(defaults read /Library/Preferences/com.apple.TimeMachine.plist | grep AutoBackup | sed 's/    AutoBackup = //' | sed 's/;//g' ) )


# Detect if the variable is enabled/disabled
if [ ${autoBackup} == "0" ]
then
    echo "Automatic Backups Not Enabled"
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

    IFS=$'\n'
    bytesAvailable=( $(defaults read /Library/Preferences/com.apple.TimeMachine.plist | grep BytesAvailable | sed 's/            BytesAvailable = //' | sed 's/;//g' ) )
    bytesUsed=( $(defaults read /Library/Preferences/com.apple.TimeMachine.plist | grep BytesUsed | sed 's/            BytesUsed = //' | sed 's/;//g' ) )
    lastDestinationID=( $(defaults read /Library/Preferences/com.apple.TimeMachine.plist | grep LastDestinationID | sed 's/    LastDestinationID = //' | sed 's/;//' | sed 's/,//' | sed 's/"//g' ) )
    localizedDiskImageVolumeName=( $(defaults read /Library/Preferences/com.apple.TimeMachine.plist | grep LocalizedDiskImageVolumeName | sed 's/    LocalizedDiskImageVolumeName = //' | sed 's/;//' | sed 's/,//' | sed 's/"//g' ) )
    skipPaths=( $(defaults read /Library/Preferences/com.apple.TimeMachine.plist | sed -n "/    SkipPaths =     (/,/);/p" | sed 's/    SkipPaths =     (//' |sed 's/);//' | sed 's/"//g' | sed 's/,//g' | sed '/^\s*$/d' | sed 's/ //g' ) )
    skipSystemFiles=( $(defaults read /Library/Preferences/com.apple.TimeMachine.plist | sed -n "/    SkipSystemFiles = /,/);/p" | sed 's/    SkipSystemFiles = //' |sed 's/);//' | sed '/^\s*$/d' | sed 's/"//g' | sed 's/,//g' | sed 's/}//g' | sed 's/;//g' | sed '/^\s*$/d' | sed 's/ //g') )
    snapshotDates=( $(defaults read /Library/Preferences/com.apple.TimeMachine.plist | sed -n "/            SnapshotDates =             (/,/);/p" | sed 's/            SnapshotDates =             (//' | sed 's/"//g' | sed 's/,//g' | sed 's/);//g' | sed '/^\s*$/d' | sed 's/+.*//' | sed 's/ //g') )
    unset IFS

    echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Backup Volume Name</key>" >> "$outputFile"
    echo "<string>$localizedDiskImageVolumeName</string>" >> "$outputFile"

    echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Automatic Backup</key>" >> "$outputFile"
    echo "<integer>$autoBackup</integer>" >> "$outputFile"

    echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Bytes Available</key>" >> "$outputFile"
    echo "<integer>$bytesAvailable</integer>" >> "$outputFile"

    echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Bytes Used</key>" >> "$outputFile"
    echo "<integer>$bytesUsed</integer>" >> "$outputFile"

    echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Last Destination ID</key>" >> "$outputFile"
    echo "<string>$lastDestinationID</string>" >> "$outputFile"

    if [ "$skipPaths" != "" ]
    then
        for path in "${skipPaths[@]}"
        do
            echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Skipped Paths:$path</key>" >> "$outputFile"
            echo "<string>$path</string>" >> "$outputFile"
        done
    else
        echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Skipped Paths</key>" >> "$outputFile"
        echo "<string>No Skipped Paths</string>" >> "$outputFile"
    fi

    if [ "$skipSystemFiles" != "0" ]
    then
        for systemFiles in "${skipSystemFiles[@]}"
        do
            echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Skipped System Files:$systemFiles</key>" >> "$outputFile"
            echo "<string>$systemFiles</string>" >> "$outputFile"
        done
    else
        echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Skipped System Files</key>" >> "$outputFile"
        echo "<string>No Skipped System Files</string>" >> "$outputFile"
    fi

    if [ "$snapshotDates" != "" ]
    then
        for snapshot in "${snapshotDates[@]}"
        do
            echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Snapshot Dates:$snapshot</key>" >> "$outputFile"
            echo "<string>$snapshot</string>" >> "$outputFile"
        done
    else
        echo "<key>Time Machine - (Backup Volume Name:$localizedDiskImageVolumeName) - Snapshot Dates</key>" >> "$outputFile"
        echo "<string>No Snapshots Present</string>" >> "$outputFile"
    fi


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

