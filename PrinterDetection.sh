#!/bin/sh

#  PrinterDetection.sh
#  
#
#  Created by Bennett Norton on 3/2/16.

# printer to detect if installed, this needs to match exactly with the output of lpstat -a without all of the text beginning with accept
printerName="Brother_HL_5370DW_series"


# lpstat - v is used to get the description name shown in the Printers and Scanners settings
printerArray=( $( lpstat -v | awk '{print $3}' | sed 's/:$//' ) )

# compare the installed printers against the desired printer and exit with the approrpriate return code
if [[ $printerArray == *"$printerName"* ]] ; then
    echo "Found: $printerName already installed"
    echo "Reason: $printerName already installed"
    echo "Expected: $printerName to be installed"
    echo "Detected: 0"
    exit 0
else
    echo "Found: $printerName not currently installed"
    echo "Reason: $printerName not currently installed"
    echo "Expected: $printerName to be installed"
    echo "Detected: 1"
    exit 1
fi

