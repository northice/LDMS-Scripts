#!/bin/bash 
## replace "http://192.168.29.13/ldlogon/mac/" with your core server FQDN or IP
## replace "BaseMacAgentnoav.dmg" with your agent name, remembering to appropriately handle spaces in the name if applicable.
CORE=http://192.168.29.13/ldlogon/mac/
AGENTNAME=BaseMacAgentnoav.dmg

## detect if the agent is already installed
if [ -d "/Library/Application Support/LANDESK" ]; then
	echo 'The LANDESK Agent is Installed'
	exit 1
	
	else echo 'The LANDESK Agent Needs to be Installed'
	
	## download the agent
	curl -o $AGENTNAME $CORE/$AGENTNAME

    ## mount the dmg
    hdiutil attach $AGENTNAME

	## install the agent
    sudo -S installer -pkg /Volumes/LDMSClient/ldmsagent.pkg -target /
	
	## delete the files downloaded
	hdiutil detach /volumes/LDMSClient
    rm $AGENTNAME
	exit 0
fi	
	