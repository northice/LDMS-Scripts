#!/bin/sh

#  MS Automatically Check for Updates Detection.sh
#  Created by Bennett Norton on 4/5/16.



# The auto update setting is found at /Users/$username/Library/Preferences/com.microsoft.autoupdate2.plist
userList=`dscl . list /Users shell | grep -v false | sed 's/_.*//' | sed 's/root//' | sed 's/Guest//' | sed 's/ .*//' | sed '/^$/d'`

# compare the returned value with your desired state
# a MSAutoUpdateSetting of Automatic means it is enabled
# a MSAutoUpdateSetting of Manual means it is disabled


for userName in $userList
do
defaults write /Users/$userName/Library/Preferences/com.microsoft.autoupdate2.plist HowToCheck -string "Automatic"
chown root:admin /Users/$userName/Library/Preferences/com.microsoft.autoupdate2.plist
chmod 644 /Users/$userName/Library/Preferences/com.microsoft.autoupdate2.plist
done
