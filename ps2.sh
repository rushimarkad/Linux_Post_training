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
    echo "Log File $i" > "$log_file"
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
    sleep 120
  done &
}

# Create the log files
create_log_files

# Call the function to generate random lines and append them to log files
generate_random_logs

echo "Process in backround"
