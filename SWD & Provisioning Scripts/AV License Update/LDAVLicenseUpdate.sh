#!/bin/sh

#  LDAVLicenseInstall
#  Created by Bennett Norton on 9/21/16.
#  This script will download the latest LANDESK AV license key and apply it


#Script Variables
#change the IP address to match your core server IP address
fileToCopy="http://192.168.29.13/ldlogon/avclient/install/key/ldav.key"
destinationLocation="/Library/Application Support/LANDesk/sdcache"


#sdclient downloads the license key and the kav addkey applies the key
/Library/Application\ Support/LANDesk/bin/sdclient -noinstall -package "$fileToCopy" -destdir "$destinationLocation"
kav addkey /Library/Application\ Support/LANDesk/sdcache/ldav.key