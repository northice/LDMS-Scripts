#!/bin/sh

#  mdmAutomaticEnrollment.sh
#  Created by Bennett Norton on 11/1/16.
#  This script will enroll a LANDESK Management Suite managed macOS device with an additional MDM profile for support with features like VPP

# NOTE: This script assumes the Mac to be enrolled with an MDM profile is currently under management within LANDESK Management Suite, with a valid agent, and that the Mac has already installed the LANDESK MDM Enrollment Application found at https://community.landesk.com/docs/DOC-42347


#Script Variables
#change the variables to match with a valid LANDESK Management Suite user, corresponding password and enrollment server URL.  The server URL format should be the fully qualified name of the Cloud Service Appliance / LANDESK Server name.

landeskUserAccount="landeskadmin"
landeskPassword="adminpassword"
enrollmentServerURL="fullyqualified.cloudserviceappliance.com/landeskServerName"


#Enroll the managed Mac device with MDM

/Applications/LANDESK\ MDM\ Enroller.app/Contents/MacOS/ldmdmenroll -u "$landeskUserAccount" -p "$landeskPassword" -m "$enrollmentServerURL"


