#!/bin/sh

#  MS Automatically Check for Updates Detection.sh
#  Created by Bennett Norton on 4/20/16.



# The auto update setting is found at /Users/$username/Library/Preferences/com.microsoft.autoupdate2.plist

userList=`dscl . list /Users shell | grep -v false | sed 's/_.*//' | sed 's/root//' | sed 's/Guest//' | sed 's/ .*//' | sed '/^$/d'`
for userName in $userList
do

    MSAutoUpdateSetting=( $( defaults read /Users/$userName/Library/Preferences/com.microsoft.autoupdate2.plist HowToCheck ) )

# compare the returned value with your desired state
# a MSAutoUpdateSetting of Automatic means it is enabled
# a MSAutoUpdateSetting of Manual means it is disabled

    if [[ $MSAutoUpdateSetting == *"Automatic"* ]] ; then
        echo "Found: The option for 'Microsoft Automatically Check for Updates' is currently enabled"
        echo "Reason: The value for 'Microsoft Automatically Check for Updates' is: $MSAutoUpdateSetting."
        echo "Expected: The value for 'Microsoft Automatically Check for Updates' should be Manual"
        echo "Detected: 1"
        exit 1
    else
        echo "Found: The option for 'Microsoft Automatically Check for Updates' is already disabled"
        echo "Reason: The value for 'Microsoft Automatically Check for Updates' is: $MSAutoUpdateSetting."
        echo "Expected: The value for 'Microsoft Automatically Check for Updates' should be Manual"
        echo "Detected: 0"
        exit 0
    fi
done
