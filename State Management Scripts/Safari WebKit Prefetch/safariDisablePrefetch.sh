#!/bin/sh

#  disableSafariPrefetch.sh
#  Created by Bennett Norton on 10/03/16.
#  This script will disable the prefetching for Safari


defaults write com.apple.safari WebKitDNSPrefetchingEnabled -boolean false
