#!/bin/bash

set -e

# Take varaibles from config file
source variable.ini

# Set email settings
EMAIL_SUBJECT="Log files with ERROR or WARNINGS"
EMAIL_BODY=""

# Create the destination directory if it doesn't exist
mkdir -p $DEST_DIR

# Function to find and copy log files containing ERROR or WARNINGS
function copy_logs {
  # Find log files containing ERROR or WARNINGS
  find $SRC_DIR -name "*.log" -type f -mmin -2 -exec grep -Hn "ERROR\|WARNINGS" {} \; | xargs -I{} cp {} $DEST_DIR
}

# Function to send email with log file details
function send_email {
  # Update the email body with the new logs files
  EMAIL_BODY=""
  while read LINE
  do
    EMAIL_BODY+="$LINE\n"
  done < <(find $DEST_DIR -name "*.log" -type f -mmin -60 -exec grep -Hn "ERROR\|WARNINGS" {} \; | sed 's/:[^:]*:/: line /g')

  # Send the email with the details of the log files
  echo -e "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" "$TO_ADDRESS"
}

# Run the script continuously in an infinite loop
while true
do
  copy_logs
  if [ $(date +%M) = "00" ]; then
    send_email
  fi
  sleep 60
done

