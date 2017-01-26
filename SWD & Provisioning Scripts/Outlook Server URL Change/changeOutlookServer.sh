#!/usr/bin/env osascript

#  changeOutlookServer.sh
#  Created by Bennett Norton on 1/25/17.

tell application "Microsoft Outlook"
    set server of exchange account 1 to "https://outlook.office365.com/"
end tell
