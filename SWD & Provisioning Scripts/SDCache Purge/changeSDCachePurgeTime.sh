#!/bin/sh

#  changeSDCachePurgeTime
#  Created by Bennett Norton on 9/21/16.
#  This script will copy the updated SDCache XML to the target machine with the updated sdcache time purge


#Script Variables
#change the IP address to match your http package share hosting the updated ldcron-sdclean.xml file
fileToCopy="http://192.168.29.13/SoftwareDist/MacPackages/ldcron-sdclean.xml"
destinationLocation="/Library/Application Support/LANDesk/scheduler"


#sdclient downloads the license key and the kav addkey applies the key
/Library/Application\ Support/LANDesk/bin/sdclient -noinstall -package "$fileToCopy" -destdir "$destinationLocation"
