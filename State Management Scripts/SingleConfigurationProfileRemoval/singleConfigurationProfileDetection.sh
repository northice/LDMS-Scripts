#!/bin/sh

#  singleConfigurationProfileDetection.sh
#  Created by Bennett Norton on 2/6/17.
#  Detects the whether a specific profile exists on a machine


#  Profile Identifier Name Variable
#  Change this name to match the profile identifier you want to remove
#  Find the name by typing sudo /usr/bin/profiles -P in Terminal

profileIdentifier="com.landesk.profile"

# create an output variable with the the potential profile from the machine
# grep filters all of the results to only show that which matches our desired configuration profile
# awk allows us to pull just the data we're looking for from the command line

discoveredProfileIdentifier=( $( sudo /usr/bin/profiles -P | grep "$profileIdentifier" | awk '{print $4}') )


if [[ $profileIdentifier != $discoveredProfileIdentifier ]] ; then
    echo "Found: Configuration profile $profileIdentifier was not found on the machine."
    echo "Reason: $profileIdentifier not intalled."
    echo "Expected: $profileIdentifier to not exist."
    echo "Detected: 0"
    exit 0
else
    echo "Found: Configuration profile $discoveredProfileIdentifier was found on the machine."
    echo "Reason: $discoveredProfileIdentifier intalled."
    echo "Expected: $discoveredProfileIdentifier to not exist."
    echo "Detected: 1"
    exit 1
fi
