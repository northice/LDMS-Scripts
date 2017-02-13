#!/bin/sh

#  domainBind.sh
#  Created by Bennett Norton on 11/14/16.
#  This script will bind a Mac to the specified Active Directory domain

# Script Variables
adDomain=mydomain.com
adminUser=administrator
adminPassword=adminPassword
computerID=$( scutil --get ComputerName )


# Do the domain binding
dsconfigad -add "${adDomain}" -username "${adminUser}" -password "${adminPassword}" \
-computer "${computerID}"
