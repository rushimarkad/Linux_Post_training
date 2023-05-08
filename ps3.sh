#!/bin/bash

# set time zone to US Eastern time
export TZ=EST5EDT

# Define folder path, age and compression threshold in days
FOLDER="/usr/training"
AGE_THRESHOLD=30
COMPRESSION_THRESHOLD=2

# Delete old log files and write the paths to a log file
find "$FOLDER" -name "*.log" -type f -mtime +$AGE_THRESHOLD -delete -print > /home/rushikesh/deleted_files.log

# Send email with deleted file list as attachment
DELETED_FILES_SUBJECT="Deleted file list $(date +'%Y-%m-%d %H:%M:%S')"
echo -e "Please find attached the list of deleted files.\n\n" | mailx -s "$DELETED_FILES_SUBJECT" -A /home/rushikesh/deleted_files.log -- rushikesh.markad@afourtech.com

# Compress files older than the compression threshold
COMPRESSED_FILES=$(find "$FOLDER" -type f -mtime +$COMPRESSION_THRESHOLD -exec gzip {} \; -exec echo {} \;)

# Send email with compressed file list as email body
COMPRESSED_FILES_SUBJECT="Compressed file list $(date +'%Y-%m-%d %H:%M:%S')"
echo -e "Please find below the list of compressed files:\n\n$COMPRESSED_FILES" | mailx -s "$COMPRESSED_FILES_SUBJECT" rushikesh.markad@afourtech.com

# set time zone again to IST
export TZ="Asia/Kolkata"
