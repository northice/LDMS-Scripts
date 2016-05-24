#!/bin/sh

#  CertificateCollection.sh
#  This script will collect all of the local users from an OS X box and report them to the Core Server
#
#  Created by Bennett Norton on 3/28/16.
#

########################################################################
###   Part 1 - Create an Output File of Certificates on the Machine  ###
########################################################################

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


# Create array of system certificates
IFS=$'\n'
allSystemCertificates=( $(security dump-keychain  "/Library/Keychains/System.keychain" | grep '"alis"<blob>' | sed 's/"alis"<blob>=//' | sed 's/    //' | sed 's/"//' | sed 's/"//') )
unset IFS

for cert in "${allSystemCertificates[@]}"
do

# create the variables for the different attributes

    sha1Hash=( $(security find-certificate -a -c "$cert" -Z /Library/Keychains/System.keychain | grep "SHA-1 hash:" | sed 's/SHA-1 hash://' ) )
    keychain=( $(security find-certificate -a -c "$cert" -Z /Library/Keychains/System.keychain | grep "keychain:" | sed 's/keychain://' | sed 's/"//' | sed 's/"//' | sed 's/ //') )
    version=( $(security find-certificate -a -c "$cert" -Z /Library/Keychains/System.keychain | grep "version:" | sed 's/version://' | sed 's/ //' ) )
    issued=( $(security find-certificate -a -c "$cert" -Z /Library/Keychains/System.keychain | grep '"issu"<blob>=' | sed 's/"issu"<blob>=//' | sed 's/    //') )

    echo "<key>Certificates - System Certificates - (Name:$cert) - Name</key>" >> "$outputFile"
    echo "<string>$cert</string>" >> "$outputFile"

    echo "<key>Certificates - System Certificates - (Name:$cert) - SHA-1 Hash</key>" >> "$outputFile"
    echo "<string>$sha1Hash</string>" >> "$outputFile"

    echo "<key>Certificates - System Certificates - (Name:$cert) - Keychain</key>" >> "$outputFile"
    echo "<string>$keychain</string>" >> "$outputFile"

    echo "<key>Certificates - System Certificates - (Name:$cert) - Version</key>" >> "$outputFile"
    echo "<integer>$version</integer>" >> "$outputFile"

    echo "<key>Certificates - System Certificates - (Name:$cert) - Issued</key>" >> "$outputFile"
    echo "<string>$issued</string>" >> "$outputFile"

done


# Create array of system certificates
IFS=$'\n'
allSystemRootCertificates=( $(security dump-keychain /System/Library/Keychains/SystemRootCertificates.keychain | grep '"alis"<blob>' | sed 's/"alis"<blob>=//' | sed 's/    //' | sed 's/"//' | sed 's/"//') )
unset IFS

for rootCert in "${allSystemRootCertificates[@]}"
do

    # create the variables for the different attributes

    sha1Hash=( $(security find-certificate -a -c "$rootCert" -Z /System/Library/Keychains/SystemRootCertificates.keychain | grep "SHA-1 hash:" | sed 's/SHA-1 hash://' ) )
    keychain=( $(security find-certificate -a -c "$rootCert" -Z /System/Library/Keychains/SystemRootCertificates.keychain | grep "keychain:" | sed 's/keychain://' | sed 's/"//' | sed 's/"//' | sed 's/ //') )
    version=( $(security find-certificate -a -c "$rootCert" -Z /System/Library/Keychains/SystemRootCertificates.keychain | grep "version:" | sed 's/version://' | sed 's/ //' ) )
    issued=( $(security find-certificate -a -c "$rootCert" -Z /System/Library/Keychains/SystemRootCertificates.keychain | grep '"issu"<blob>=' | sed 's/"issu"<blob>=//' | sed 's/    //') )

    echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - Name</key>" >> "$outputFile"
    echo "<string>$rootCert</string>" >> "$outputFile"

    if [ "$sha1Hash" != "" ]
    then
        echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - SHA-1 Hash</key>" >> "$outputFile"
        echo "<string>$sha1Hash</string>" >> "$outputFile"
    else
        echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - SHA-1 Hash</key>" >> "$outputFile"
        echo "<string>No Value</string>" >> "$outputFile"
    fi

    if [ "$keychain" != "" ]
    then
        echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - Keychain</key>" >> "$outputFile"
        echo "<string>$keychain</string>" >> "$outputFile"
    else
        echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - Keychain</key>" >> "$outputFile"
        echo "<string>No Value</string>" >> "$outputFile"
    fi

    if [ "$version" != "" ]
    then
        echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - Version</key>" >> "$outputFile"
        echo "<integer>$version</integer>" >> "$outputFile"
    else
        echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - Version</key>" >> "$outputFile"
        echo "<integer>0</integer>" >> "$outputFile"
    fi

    if [ "$issued" != "" ]
    then
        echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - Issued</key>" >> "$outputFile"
        echo "<string>$issued</string>" >> "$outputFile"
    else
        echo "<key>Certificates - System Root Certificates - (Name:$rootCert) - Issued</key>" >> "$outputFile"
        echo "<string>No Value</string>" >> "$outputFile"
    fi
done


# close out the plist structure
echo "</dict>" >> "$outputFile"
echo "</plist>" >> "$outputFile"

#################################################################
###   Part 2 - Force an Inventory Scan to Run                 ###
#################################################################

# -e forces a hardware and software scan and -s forces a sync
# this step is optional
#/Library/Application\ Support/LANDesk/bin/ldiscan -e -s
