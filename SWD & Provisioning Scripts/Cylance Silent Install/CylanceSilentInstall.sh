#!/bin/sh

#  CylanceTokenCreation.sh
#  Created by Bennett Norton on 8/30/16.
#  This script will copy a file from the source destination and place it on the Mac into the destination folder
#  Change the path variables


#Script Variables
#change these variables to match your token and desired destination paths
cylanceToken="cylanceCustomToken"
cylancePackageName="CylancePROTECT.zip"
cylancePackageLocation="http://ldserver.ldlab.org/SoftwareDist/MacPackages/Cylance/"
cylancePackageAndTokenDestination="/private/tmp/Cylance"



#Check to see if destination exists and if not, create it
if [ ! -d "$cylancePackageAndTokenDestination" ]; then
echo "Location doesn't exist.  Creating directory"
mkdir $cylancePackageAndTokenDestination
echo "$cylancePackageAndTokenDestination created"
fi

#Output token to file
#You shouldn't need to make any changes here

echo "$cylanceToken" > "$cylancePackageAndTokenDestination/cyagent_install_token"

#Download package installer
/Library/Application\ Support/LANDesk/bin/sdclient -noinstall -package "$cylancePackageLocation/""$cylancePackageName" -destdir "$cylancePackageAndTokenDestination"

#unzip package installer
unzip "$cylancePackageAndTokenDestination/""$cylancePackageName" -d "$cylancePackageAndTokenDestination"

#Install Cylance
sudo installer -pkg /private/tmp/Cylance/CylancePROTECT.pkg -target /

#Delete Cylance folder
rm -rf "$cylancePackageAndTokenDestination"