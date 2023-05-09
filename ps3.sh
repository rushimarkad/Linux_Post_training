#!/bin/bash

#Print timestamp for log
date +"%d-%m-%Y %H:%M:%S" >> /home/rushikesh/post_training/ps.log

#Take the variable from config file
source config.cfg

# set time zone to US Eastern time
export TZ="America/Los_Angeles"
echo "Timezone changed to America/Los_Angeles successfully" >> /home/rushikesh/post_training/ps.log

# Delete old log files and write the paths to a log file
find "$FOLDER" -name "*.log" -type f -mtime +$AGE_THRESHOLD -delete -print > /home/rushikesh/deleted_files.log
if [[ -s /home/rushikesh/deleted_files.log ]]; then
    # Send email with deleted file list as attachment
    DELETED_FILES_SUBJECT="Deleted file list $(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "Please find attached the list of deleted files.\n\n" | mailx -s "$DELETED_FILES_SUBJECT" -A /home/rushikesh/deleted_files.log -- rushikesh.markad@afourtech.com
    echo "Following files are deleted successfully" >> /home/rushikesh/post_training/ps.log
    cat /home/rushikesh/deleted_files.log >> /home/rushikesh/post_training/ps.log
    echo "mail sent with list of deleted files" >> /home/rushikesh/post_training/ps.log
else
    echo "None of the file deleted" >> /home/rushikesh/post_training/ps.log
fi


# Compress files older than the compression threshold
COMPRESSED_FILES=$(find "$FOLDER" -type f -mtime +$COMPRESSION_THRESHOLD -exec gzip {} \; -exec echo {} \;)

if [[ ! -z "$COMPRESSED_FILES" ]]; then
    # Send email with compressed file list as email body
    COMPRESSED_FILES_SUBJECT="Compressed file list $(date +'%Y-%m-%d %H:%M:%S')"
    echo -e "Please find below the list of compressed files:\n\n$COMPRESSED_FILES" | mailx -s "$COMPRESSED_FILES_SUBJECT" rushikesh.markad@afourtech.com
    echo "Following files are compressed successfully : $COMPRESSED_FILES" >> /home/rushikesh/post_training/ps.log
    echo "mail sent with list of compressed files" >> /home/rushikesh/post_training/ps.log
else
    echo "None of the file is compressed" >> /home/rushikesh/post_training/ps.log
fi


# set time zone again to IST
export TZ="Asia/Kolkata"
echo "Timezone changed to Asia/Kolkata successfully" >> /home/rushikesh/post_training/ps.log
