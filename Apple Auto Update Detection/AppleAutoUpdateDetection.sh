#!/bin/sh

#  Apple Automatically Check for Updates Detection.sh
#  Created by Bennett Norton on 4/5/16.

# The auto update setting is found at /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled
autoUpdateSetting=( $( defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled ) )

# compare the returned value with your desired state
# a autoUpdateSetting of 1 means it is enabled
# a autoUpdateSetting of 0 means it is disabled

if [[ $autoUpdateSetting == *"0"* ]] ; then
    echo "Found: The option to 'Automatically Check for Updates' is already disabled"
    echo "Reason: The value for 'Automatically Check for Updates' is: $autoUpdateSetting."
    echo "Expected: The value for 'Automatically Check for Updates' should be 0"
    echo "Detected: 0"
    exit 0
else
    echo "Found: The option to 'Automatically Check for Updates' is currently enabled"
    echo "Reason: The value for 'Automatically Check for Updates' is: $autoUpdateSetting."
    echo "Expected: The value for 'Automatically Check for Updates' should be 0"
    echo "Detected: 1"
    exit 1
fi

