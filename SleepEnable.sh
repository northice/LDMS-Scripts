#!/bin/sh

#  Enable "Put Hard Disks to Sleep When Possible".sh
#
#
#  Created by Bennett Norton on 4/5/16.



# The sleep setting is found in the com.apple.PowerManagement.plist file
# The detection logic has been written in another script - but the command below is what is called
#sleepSetting=( $( defaults read /Library/Preferences/SystemConfiguration/com.apple.PowerManagement.plist | grep "Disk Sleep Timer" | sed 's/;.*//'| awk '{print $5}') )

# a disksleep value of 10 means it is enabled
# a disksleep value of 0 means it is disabled
# this setting can be applied for all power states or just when on battery

# the -a switch will enable the disk sleep setting for all power states
pmset -a disksleep 10

# the -b switch will enable the disk sleep setting for just the battery state
#pmset -b disksleep 10


