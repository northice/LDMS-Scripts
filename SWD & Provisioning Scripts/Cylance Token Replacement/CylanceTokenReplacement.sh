#!/bin/sh

#  CylanceTokenReplacement.sh
#  Created by Bennett Norton and Logrhythm SIEM on 10/20/16.
#  This script will stop the Cylance service, replace the token file, and restart Cylance

#Script Variable
#change the variables to match your token
newCylanceToken="newCylanceCustomToken"

#Don't change these variables
cylanceTokenLocation="/Library/Application Support/Cylance/Desktop/registry/LocalMachine/Software/Cylance/Desktop/"
cylanceValuesXML="values.xml"

#Stop the Cylance service
launchctl unload /Library/LaunchDaemons/com.cylance.agent_service.plist

#Make a backup of the values.xml and then edit the by adding in the InstallToken key
sed -i.backup 's/<\/values>/<value name=\"InstallToken\" type=\"string\">'"$newCylanceToken"'<\/value><\/values>/g' "$cylanceTokenLocation/$cylanceValuesXML"

#Start the Cylance service
launchctl load /Library/LaunchDaemons/com.cylance.agent_service.plist
