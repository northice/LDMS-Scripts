#!/bin/sh

#  WebKitDNSPrefetching Detection.sh
#  Created by Bennett Norton on 10/3/16

# The WebKitDNSPrefetching setting is found at /Users/$username/Library/Preferences/com.apple.safari WebKitDNSPrefetchingEnabled
safariPrefetchSetting=( $( defaults read com.apple.safari WebKitDNSPrefetchingEnabled ) )

# compare the returned value with your desired state
# a safariPrefetchSetting of 0 means it is disabled - this is what you want if you want to speed up the browser
# a safariPrefetchSetting of does not exist means it is enabled 
if [[ $safariPrefetchSetting == 0 ]] ; then
        echo "Found: The option for 'WebKitDNSPrefetching' is already disabled"
        echo "Reason: The value for 'WebKitDNSPrefetching' is: $safariPrefetchSetting."
        echo "Expected: The value for 'WebKitDNSPrefetching' should be Manual"
        echo "Detected: 0"
        exit 0
    else
        echo "Found: The option for 'WebKitDNSPrefetching' is currently enabled"
        echo "Reason: The value for 'WebKitDNSPrefetching' is currently applied"
        echo "Expected: The value for 'WebKitDNSPrefetching' should be disabled"
        echo "Detected: 1"
        exit 1
fi

