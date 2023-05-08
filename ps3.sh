#!/bin/bash

#Take the variable from config file
source config.cfg

# set time zone to US Eastern time
export TZ="America/Los_Angeles"
echo "Timezone changed to America/Los_Angeles successfully"

# Delete old log files and write the paths to a log file
find "$FOLDER" -name "*.log" -type f -mtime +$AGE_THRESHOLD -delete -print > /home/rushikesh/deleted_files.log
if [[ -s /home/rushikesh/deleted_files.log ]]; then
    # Send email with deleted file list as attachment
    DELETED_FILES_SUBJECT="Deleted file list $(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "Please find attached the list of deleted files.\n\n" | mailx -s "$DELETED_FILES_SUBJECT" -A /home/rushikesh/deleted_files.log -- rushikesh.markad@afourtech.com
    echo "Following files are deleted successfully"
    cat /home/rushikesh/deleted_files.log
    echo "mail sent with list of deleted files"
else
    echo "None of the file deleted"
fi


# Compress files older than the compression threshold
COMPRESSED_FILES=$(find "$FOLDER" -type f -mtime +$COMPRESSION_THRESHOLD -exec gzip {} \; -exec echo {} \;)

if [[ ! -z "$COMPRESSED_FILES" ]]; then
    # Send email with compressed file list as email body
    COMPRESSED_FILES_SUBJECT="Compressed file list $(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "Please find below the list of compressed files:\n\n$COMPRESSED_FILES" | mailx -s "$COMPRESSED_FILES_SUBJECT" rushikesh.markad@afourtech.com
    echo "Following files are compressed successfully : $COMPRESSED_FILES"
    echo "mail sent with list of compressed files"
else
    echo "None of the file is compressed"
fi


# set time zone again to IST
export TZ="Asia/Kolkata"
