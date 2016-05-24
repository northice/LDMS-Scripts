#!/bin/sh

#  UserCollection.sh
#  This script will collect all of the local users from an OS X box and report them to the Core Server
#
#  Created by Bennett Norton on 3/28/16.
#

#################################################################
###   Part 1 - Create an Output File of Users on the Machine  ###
#################################################################

# Set the Output file path, do not change
outputFile="/Library/Application Support/LANDesk/Data/ldscan.core.data.plist"

# If you have multiple different custom scripts, you may not want to delete this plist file
if [ -e "$outputFile" ]
then
cp "$outputFile" "$outputFile.old"
rm "$outputFile"
fi


echo '<?xml version="1.0" encoding="UTF-8"?>'  >> "$outputFile"
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> "$outputFile"
echo '<plist version="1.0">' >> "$outputFile"
echo "<dict>" >> "$outputFile"


# Create array of Users
# grep -v false removes
# sed removes any accounts beginning with _, deletes all text after the first space and removes the root account and the .^ $/d deletes all blank lines
userDetails()
{
userList=`dscl . list /Users shell | grep -v false | sed 's/_.*//' | sed 's/root//' | sed 's/ .*//' | sed '/^$/d'`
for userName in $userList
do
    echo $userName
    userNameRealName=`dscl . read /Users/$userName RealName |  cut -d : -f 2 | sed 's/^[ \t]*//' | sed '/./,$!d'`
    userNameUID=`dscl . read /Users/$userName UniqueID |  cut -d : -f 2 | sed 's/^[ \t]*//' | sed '/./,$!d'`
    userNamePrimaryGroupID=`dscl . read /Users/$userName PrimaryGroupID |  cut -d : -f 2 | sed 's/^[ \t]*//' | sed '/./,$!d'`
    userNameUserShell=`dscl . read /Users/$userName UserShell |  cut -d : -f 2 | sed 's/^[ \t]*//' | sed '/./,$!d'`
    userNameNFSHomeDirectory=`dscl . read /Users/$userName NFSHomeDirectory |  cut -d : -f 2 | sed 's/^[ \t]*//' | sed '/./,$!d'`

# If the Short Name is missing, replace with full name
if [ "$userNameRealName" != "" ] ; then
    echo "Valid Name"
else
    userNameRealName=$userName
# Remove quotes and leading/trailing spaces
    userNameRealName=`echo "$userNameRealName" | tr \" " "`
    userNameRealName=`echo "$userNameRealName" | sed -e 's/^ *//' -e 's/ *$//'`
fi


if [[ "$userNameUID" -lt 999  ]] ; then


    echo "<key>Local Users and Groups - Local User Accounts - (Name:$userName) - Name</key>" >> "$outputFile"
    echo "<string>$userName</string>" >> "$outputFile"
    echo "<key>Local Users and Groups - Local User Accounts - (Name:$userName) - Full Name</key>" >> "$outputFile"
    echo "<string>$userNameRealName</string>" >> "$outputFile"
    echo "<key>Local Users and Groups - Local User Accounts - (Name:$userName) - User ID </key>" >> "$outputFile"
    echo "<string>$userNameUID</string>" >> "$outputFile"
    echo "<key>Local Users and Groups - Local User Accounts - (Name:$userName) - Primary Group ID</key>" >> "$outputFile"
    echo "<string>$userNamePrimaryGroupID</string>" >> "$outputFile"


    if [ "$userNameUserShell" != "" ] ; then
        echo "<key>Local Users and Groups - Local User Accounts - (Name:$userName) - Shell</key>" >> "$outputFile"
        echo "<string>$userNameUserShell</string>" >> "$outputFile"

    else
        echo "<key>Local Users and Groups - Local User Accounts - (Name:$userName) - Shell</key>" >> "$outputFile"
        echo "<string> </string>" >> "$outputFile"

    fi

    if [ "$userNameNFSHomeDirectory" != "" ] ; then
        echo "<key>Local Users and Groups - Local User Accounts - (Name:$userName) - Home Path</key>" >> "$outputFile"
        echo "<string>$userNameNFSHomeDirectory</string>" >> "$outputFile"


    else
        echo "<key>Local Users and Groups - Local User Accounts - (Name:$userName) - Home Path</key>" >> "$outputFile"
        echo "<string> </string>" >> "$outputFile"
    fi

fi

done
}


# Create array of Groups
# grep -v false removes
# sed removes any accounts beginning with _, deletes all text after the first space and removes the root account and the .^ $/d deletes all blank lines
groupDetails()
{
groupList=`dscl . list /Groups | grep -v false | sed 's/_.*//' | sed 's/root//' | sed 's/ .*//' | sed '/^$/d'`
for groupName in $groupList
    do
    echo $groupName
    groupNameRealName=`dscl . read /Groups/$groupName RealName | cut -d : -f 2 | sed 's/^[ \t]*//' | sed '/./,$!d'`
    groupNameGroupMembership=`dscl . read /Groups/$groupName GroupMembership |  cut -d : -f 2 | sed 's/^[ \t]*//' | sed '/./,$!d'`
    groupNamePrimaryGroupID=`dscl . read /Groups/$groupName PrimaryGroupID |  cut -d : -f 2 | sed 's/^[ \t]*//' | sed '/./,$!d'`

# If the Short Name is missing, replace with full name
    if [ "$groupNameRealName" != "" ] ; then
    echo "Valid Name"
    else
    groupNameRealName=$groupName
# Remove quotes and leading/trailing spaces
    groupNameRealName=`echo "$groupNameRealName" | tr \" " "`
    groupNameRealName=`echo "$groupNameRealName" | sed -e 's/^ *//' -e 's/ *$//'`
    fi

    echo $groupNameRealName

# Create primary group entry
    echo "<key>Local Users and Groups - Local Groups - (Name:$groupNameRealName) - Short Name</key>" >> "$outputFile"
    echo "<string>$groupName</string>" >> "$outputFile"

# Enter Full Name
    echo $groupNameRealName
    echo "<key>Local Users and Groups - Local Groups - (Name:$groupNameRealName) - Name</key>" >> "$outputFile"
    echo "<string>$groupNameRealName</string>" >> "$outputFile"

# Enter Group Membership
    if [ "$groupNameGroupMembership" != "" ] ; then
        echo $groupNameGroupMembership

        if [ "$groupNameGroupMembership" != "GroupMembership" ] ; then
            echo "<key>Local Users and Groups - Local Groups - (Name:$groupNameRealName) - Members</key>" >> "$outputFile"
            echo "<string>$groupNameGroupMembership</string>" >> "$outputFile"
        fi
    else
        echo “GroupMembership_Empty”
        echo "<key>Local Users and Groups - Local Groups - (Name:$groupNameRealName) - Members</key>" >> "$outputFile"
        echo "<string> </string>" >> "$outputFile"
    fi

# Enter Group ID
    if [ "$groupNamePrimaryGroupID" != "" ] ; then
        echo $groupNamePrimaryGroupID
        echo "<key>Local Users and Groups - Local Groups - (Name:$groupNameRealName) - Group ID</key>" >> "$outputFile"
        echo "<string>$groupNamePrimaryGroupID</string>" >> "$outputFile"
    else
        echo “PrimaryGroupID_Empty”
        echo "<key>Local Users and Groups - Local Groups - (Name:$groupNameRealName) - Group ID</key>" >> "$outputFile"
        echo "<string> </string>" >> "$outputFile"
    fi

done
}

userDetails
groupDetails

# close out the plist structure
echo "</dict>" >> "$outputFile"
echo "</plist>" >> "$outputFile"

#################################################################
###   Part 2 - Force an Inventory Scan to Run                 ###
#################################################################

# -e forces a hardware and software scan and -s forces a sync
# this step is optional
/Library/Application\ Support/LANDesk/bin/ldiscan -e -s
