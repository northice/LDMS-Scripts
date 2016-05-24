#!/bin/sh

#  PrinterInventory.sh
#  
#
#  Created by Bennett Norton on 3/2/16.
#

#################################################################
###   Part 1 - Create an Output File of Printers Installed    ###
#################################################################

# Create the Output file with the appropriate XML structure so the inventory scanner can read the data
# The output file path
outputFile="/Library/Application Support/LANDesk/CustomData/PrinterDiscovery.xml"

# specifying the XML structure and telling to return the string to the output file
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"  > "$outputFile"

# creating the XML tag for the Printer info.
echo "<Printers>" >> "$outputFile"

# Create array of printers
# awk pulls the 3rd word from the output, removing "device for"
# sed removes the : and <blank space> from the ouput
printerArray=( $( lpstat -v | awk '{print $3}' | sed 's/:$//' ) )

# Iterate over printer array
# Detect if the array is blank
# Create a printer tag for each value in the array
if [[ -z "$printerArray" ]]; then
    echo "<Printer> No Printers Installed </Printer>" >> "$outputFile"
else
    for printer in "${printerArray[@]}" ; do
    echo "<Printer> $printer </Printer>" >> "$outputFile"
done
fi

# close the XML tag for Printers
echo "</Printers>" >> "$outputFile"

#################################################################
###   Part 2 - Force an Inventory Scan to Run                 ###
#################################################################

# -e forces a hardsare and software scan and -s forces a sync
# this step is optional
cd /Library/Application\ Support/LANDesk/bin
./ldiscan -e -s
