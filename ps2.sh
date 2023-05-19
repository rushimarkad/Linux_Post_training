#!/bin/bash

set -e

#Take the variable from config file
source variable.ini

function log_statement () {
  echo "$(date "+%d-%m-%Y %H:%M:%S") : $1" >> "$LOGPATH"
}

# Create the log files
create_log_files() {
  for ((i=1; i<=5; i++))
  do
    log_file="$LOG_DIR/log$i.log"
    touch "$log_file"
  done 
}

# Function to generate random text lines and append them to log files
generate_random_logs() {
  while true
  do
    for ((i=1; i<=5; i++))
    do
      log_file="$LOG_DIR/log$i.log"
      random_log=$(shuf -n 1 -e "ERROR: This is an error log" "WARNINGS: This is a warning log" "INFO: This is an informational message")
      echo "$random_log" >> "$log_file"
    done
    sleep 30 # For demo
    # sleep 120		#actual
  done &
}

EMAIL_SUBJECT="Log files with ERROR or WARNINGS"
EMAIL_BODY=""

# Function to send email with log file details
function send_email {
  # Update the email body with the new logs files
  EMAIL_BODY=""
  while read LINE
  do
    EMAIL_BODY+="$LINE\n"
  done < <(find $LOG_DIR -name "*.log" -type f -mmin -60 -exec grep -Hn "ERROR\|WARNINGS" {} \; | sed 's/:[^:]*:/: line /g')

  # Send the email with the details of the log files
  echo -e "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" "$TO_ADDRESS"
  log_statement "Email has been sent to $TO_ADDRESS with the files containing ERRORS/WARNINGS"
}

# Create the log files
create_log_files

# Call the function to generate random lines and append them to log files
generate_random_logs

new_logs=$(find $LOG_DIR -name "*.log" -type f -mmin -60 -exec grep -Hn "ERROR\|WARNINGS" {} \;) 
echo "$new_logs" 

# Call the function to send mails in proper format
while true
do
  if [ $(date +%M) = "00" ]; then
    send_email 
  fi
  sleep 60
done
