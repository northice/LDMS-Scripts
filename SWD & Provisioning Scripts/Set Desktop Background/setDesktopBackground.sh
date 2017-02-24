#!/usr/bin/env osascript

#  setDesktopBackground
#  Created by Bennett Norton on 1/25/17.

# you first need to download your background image you'll use
# call the directory you want to save the background image to
# set the download path to your image
do shell script "cd ~/Pictures && { curl -O http://bn-sgu-ldserver.ldlab.org/SoftwareDist/IvantiScreen1.jpg; cd -; }"

# run the applescript to set the desktop background
# make sure the paths match
# if you set the path to ~/Pictures above, then it should be ~/Pictures below
tell application "System Events"
	tell every desktop
		set picture to "~/Pictures/IvantiScreen1.jpg"
	end tell
end tell
