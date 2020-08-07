#!/bin/bash


# This script works well for removing local accounts that are older than 1 day. 
# Obviously the 1 day timeframe can be modified (-mtime +1).  

# Runs using Launch Daemon - /Library/LaunchDaemons/edu.org.deleteaccounts.plist
# version .7


DATE=`date "+%Y-%m-%d %H:%M:%S"`

# Don't delete local accounts
keep1="/Users/administrator"

currentuser=`ls -l /dev/console | cut -d " " -f 4`
keep2=/Users/$currentuser

USERLIST=`/usr/bin/find /Users -type d -maxdepth 1 -mindepth 1 -mtime +1`

for a in $USERLIST ; do
    [[ "$a" == "$keep1" ]] && continue  #skip admin
    [[ "$a" == "$keep2" ]] && continue  #skip current user
    

# Log results
echo ${DATE} - "Deleting account and home directory for" $a >> "/Library/Logs/deleted user accounts.log"
    
# Delete the account
/usr/bin/dscl . -delete $a  
    
# Delete the home directory
# dscl . list /Users UniqueID | awk '$2 > 500 { print $1 }' | grep -v Shared | grep -v admin | grep -v admin1 | grep -v .localized
/bin/rm -rf $a

done 
exit 0
