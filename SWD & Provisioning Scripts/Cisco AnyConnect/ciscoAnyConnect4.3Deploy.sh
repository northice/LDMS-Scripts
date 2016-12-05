#!/bin/sh

#  ciscoAnyConnect4.3Deploy.sh
#  Created by Bennett Norton on 11/30/16.


#File to copy
#change this to match your hosted path, it needs to be http
plistName="ChoiceChangesCiscoAnyConnect.plist"
packageName="AnyConnect.pkg"
plistFilePath="http://yourFileShareServer/Path/To/PLIST"
packageFilePath="http://yourFileShareServer/Path/To/CiscoAnyConnect"
packageToCopy="$packageFilePath"/"$packageName"
plistToCopy="$plistFilePath"/"$plistName"

#Location to copy file to
#change this to match your destination path
destinationLocation='/Library/Application\ Support/LANDesk/sdcache/CiscoAnyConnect'

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
/Library/Application\ Support/LANDesk/bin/sdclient -noinstall -package "$plistToCopy" -destdir "$destinationLocation"
installer -pkg "$destinationLocation"/"$packageName" -target / -applyChoiceChangesXML "$destinationLocation"/"$plistName"
