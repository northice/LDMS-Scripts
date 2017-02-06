#!/bin/sh

#  singleConfigurationProfileDeletion.sh
#  Created by Bennett Norton on 2/6/17.
#  Deletes a specific profile on a machine

#  Profile Identifier Name Variable
#  Change this name to match the profile identifier you want to remove
#  Find the name by typing sudo /usr/bin/profiles -P in Terminal

profileIdentifier="com.landesk.profile"

# Delete
sudo /usr/bin/profiles -R -p "$profileIdentifier"


