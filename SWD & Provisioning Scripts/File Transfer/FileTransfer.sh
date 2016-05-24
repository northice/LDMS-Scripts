#!/bin/sh

#  FileTransfer.sh
#  Created by Bennett Norton on 5/16/16.
#  This script will copy a file from the source destination and place it on the Mac into the destination folder
#  Change the path variables


#File to copy
#change this to match your hosted path, it needs to be http
fileToCopy="http://ldserver.ldlab.org/SoftwareDist/MacPackages/ExampleFile.txt"

#Location to copy file to
#change this to match your destination path
destinationLocation="/path/on/the/client"

#Check to see if destination exists and if not, create it
if [ ! -d "$destinationLocation" ]; then
echo "Location doesn't exist.  Creating directory"
mkdir $destinationLocation
echo "$destinationLocation created"
fi

#Download and execute command
#You shouldn't need to make any changes here
#-noinstall ensure the package does not get executed
#-package is the source url path
#-destdir is the destination url path

/Library/Application\ Support/LANDesk/bin/sdclient -noinstall -package "$fileToCopy" -destdir "$destinationLocation"