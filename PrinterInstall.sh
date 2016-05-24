#!/bin/sh

#  PrinterInstall.sh
#  Below are the variables and switches lpadmin will use.  For some of these switches, we'll create variables so we can easily handle change
#
#  Created by Bennett Norton on 3/12/16.
#

##############################################################
###   Part 1 - Additional Softwae Package Installer        ###
##############################################################

# This variable is used to install the additional printer software package
# This action may or may not be needed, depending on the printer manufacturer
# You can try commenting this part out and use it if the printer
# states you need additional software after just running the command below
# you'll know you need to use this step
#
# Download your printer's DMG installer and place it in an HTTP share
# Update the path below to match your path
printerInstaller="http://ldserver.ldlab.org/Patching/INTL/Custom/Brother_PrinterDrivers_MonochromeLaser_1_1_0.dmg"

#command line to install the printer software package
/Library/Application\ Support/LANDesk/bin/sdclient -package "$printerInstaller"

##############################################################
###   Part 2 - Command Line to Install the Printer         ###
##############################################################

# -E This switch is required as it enables the printer.  There are no variables associated.

# -p is the switch for the printer name. In the variable below, give the name of the printer.
# This name needs to match the output of lpstat -a in order to properly detect.
# The name cannot have spaces.  This is the same name you'll want to have in your printer detection script as well.
printerName="Brother_HL_5370DW_series"

# -D is the switch for the friendly printer name.  In the variable below, give the name of the printer, it can be anything you want.
printerDescription="Brother HL-5370DW"

# -L is the switch for the location of the printer.  Provide the location of the printer, this name can have spaces.
printerLocation="Home Office"

# -v This is the device URI.  You can choose to use ipp: or lpd:
printerIPAddress="ipp://192.168.29.250"

# we need a printerPPD file to be local on the machine
# to do this, we will need to copy the file from a network share to a local folder
# sdclient will copy the file to the LANDESK sdcache folder
cd /Library/Application\ Support/LANDesk/bin
./sdclient -noinstall -package "http://ldserver.ldlab.org/Patching/INTL/Custom/Brother_HL_5370DW_series.ppd"

# -P This is the name and path of the PPD filename copied to the machine
printerPPD="/Library/Application Support/LANDesk/sdcache/Brother_HL_5370DW_series.ppd"

# -o Do you want to share out the printer?
printerSharing="printer-is-shared=false"

# commandline lpadmin with all of its switches
lpadmin -p "$printerName" -E -v "$printerIPAddress" -P "$printerPPD" -L "$printerLocation" -o "$printerSharing"; cupsenable "$printerName"; cupsaccept "$printerName";

