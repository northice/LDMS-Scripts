#!/bin/sh

#  AlertLaunch.sh
#  Created by Bennett Norton on 2/17/17.


#File to copy
#change this to match your hosted path, it needs to be http

packageName="displayAlertAS.zip"
packageNameUnzipped="displayAlertAS.app"
packageFilePath="http://bn-sgu-ldserver.ldlab.org/SoftwareDist/MacPackages"
packageToCopy="$packageFilePath"/"$packageName"


#Location to copy file to
#change this to match your destination path
destinationLocation=/Library/Application\ Support/LANDesk/sdcache/Alert

#Check to see if destination exists and if not, create it
if [ ! -d "$destinationLocation" ]; then
echo "Location doesn't exist.  Creating directory"
mkdir $destinationLocation
echo "$destinationLocation created"
fi

#Download and execute command
#You shouldn't need to make any changes here
#-noinstall ensure the package does not get executed when downloaded
#-package is the source url path
#-destdir is the destination url path
/Library/Application\ Support/LANDesk/bin/sdclient -noinstall -package "$packageToCopy" -destdir "$destinationLocation"

unzip -o "$destinationLocation"/"$packageName" -d "$destinationLocation" 

open "$destinationLocation"/"$packageNameUnzipped"

exit 0

