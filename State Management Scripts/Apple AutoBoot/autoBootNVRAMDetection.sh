#!/bin/sh

#  autoBootNVRAMDetection.sh
#
#
#  Created by Bennett Norton on 2/2/17.
#  Detects the state of AutoBoot set in the NVRAM



# nvram AutoBoot will call and obtain the value for just the AutoBoot variable
# calling nvram -px will show all values and put the output in an XML format
# awk filters out the AutoBoot text and leaves us with just the value

autoBoot=( $( nvram AutoBoot| awk '{print $2}') )

# compare the nvram state with your desired state
# a value of %00 means the autoboot is disabled
# a value of %03 means the autoboot is enabled
# any other value means the autoboot state is undefined

if [[ $autoBoot == *"%00"* ]] ; then
    echo "Found: NVRAM AutoBoot value is $autoBoot"
    echo "Reason: NVRAM AutoBoot value is $autoBoot"
    echo "Expected: NVRAM AutoBoot to be disabled or set to %00"
    echo "Detected: 0"
exit 0
else
    echo "Found: NVRAM AutoBoot value is $autoBoot"
    echo "Reason: NNVRAM AutoBoot value is $autoBoot"
    echo "Expected: NVRAM AutoBoot to be disabled or set to %00"
    echo "Detected: 1"
exit 1
fi
