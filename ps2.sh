#!/bin/bash

set -e

# Set the source and destination directories
SRC_DIR=/var/log
DEST_DIR=/tmp/mylogs

# Create the destination directory if it doesn't exist
mkdir -p $DEST_DIR

# Find log files containing ERROR or WARNINGS and copy them to the destination directory
while true
  do
  find $SRC_DIR -name "*.log" -type f -mmin -2 -exec grep -Hn "ERROR\|WARNINGS" {} \; | while read LINE; do
    cp $(echo $LINE | cut -d ':' -f 1) $DEST_DIR
  done
  sleep 120
done

# Function to send email with log file details
