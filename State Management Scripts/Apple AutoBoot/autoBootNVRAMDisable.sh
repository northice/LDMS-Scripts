#!/bin/sh

#  autoBootNVRAMDisable.sh
#  Created by Bennett Norton on 2/2/17.
#  Sets the AutoBoot state in the NVRAM

# nvram AutoBoot=### sets the state
# a value of %00 means the autoboot is disabled
# a value of %03 means the autoboot is enabled


nvram AutoBoot=%00


