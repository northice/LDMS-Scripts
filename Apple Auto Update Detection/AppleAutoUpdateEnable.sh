#!/bin/sh

#  Apple Automatically Check for Updates Detection.sh
#  Created by Bennett Norton on 4/5/16.


# The auto update setting is found at /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled
# The detection logic has been written in another script - but the command below is what is called
#autoUpdateSetting=( $( defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled ) )

# a autoUpdateSetting of 1 means it is enabled
# a autoUpdateSetting of 0 means it is disabled


# to enable the automatic software check, use the following command
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool TRUE


