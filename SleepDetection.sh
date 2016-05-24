#!/bin/sh

#  Put Hard Disks to Sleep When Possible Detection.sh
#  Created by Bennett Norton on 4/5/16.


# The sleep setting is found in the com.apple.PowerManagement.plist file
sleepSetting=( $( defaults read /Library/Preferences/SystemConfiguration/com.apple.PowerManagement.plist | grep "Disk Sleep Timer" | sed 's/;.*//'| sed 's/ //'| awk '{print $5}') )

# compare the returned value with your desired state
# a disksleep value of 10 means it is enabled
# a disksleep value of 0 means it is disabled
# this setting can be applied for all power states or just when on battery
# as such, you'll have two values returned using the above command

if [[ $sleepSetting == "0" ]] ; then
    echo "Found: The option to 'Put Hard Disks to Sleep When Possible' is already disabled"
    echo "Reason: The value for Disk Sleep Timer is: $sleepSetting."
    echo "Expected: The value for Disk Sleep Timer should be 0"
    echo "Detected: 0"
    exit 0
else
    echo "Found: The option to 'Put Hard Disks to Sleep When Possible' is currently enabled"
    echo "Reason: The value for Disk Sleep Timer is: $sleepSetting."
    echo "Expected: The value for Disk Sleep Timer should be 0"
    echo "Detected: 1"
    exit 1
fi

