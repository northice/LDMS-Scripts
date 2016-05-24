#!/bin/sh

#  printerDeletion.sh
#  
#
#  Created by Bennett Norton on 3/14/16.




# printer to detect if installed, this needs to match exactly with the output of lpstat -a without all of the text beginning with accept
printerName="Brother_HL_5370DW_series"


# lpstat - v is used to get the description name shown in the Printers and Scanners settings
printerArray=( $( lpstat -v | awk '{print $3}' | sed 's/:$//' ) )

# compare the installed printers against the desired printer and exit with the approrpriate return code
if [[ $printerArray == *"$printerName"* ]] ; then
    lpadmin -x "$printerName"
    echo "$printerName removed"
    exit 0
else
    echo "$printerName not currently installed"
    exit 100
fi

