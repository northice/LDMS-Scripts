#!/bin/sh

#  purgeSDCache.sh
#  Created by Bennett Norton on 9/16/16.
#  This script will delete all non-standard files/folders from the LANDESK sdcache folder
#  Change the path variables


#Script Variables
#change these variables to match your token and desired destination paths
landeskPath="/Library/Application Support/LANDesk/sdcache"


#Check to see if destination path exists and if it does, delete the files older than x number of days old
#The +10 after the -mtime switch tells the command to delete everything older than 10 days.  You can adjust that number.
if [ -d "$landeskPath" ]; then
	echo "LANDESK Agent present, deleting and recreating the sdcache folder. "
	find "$landeskPath"/* -mtime +10 -exec rm -rf {} \;
fi
