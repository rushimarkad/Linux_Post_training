#! /bin/bash

set -e

# Added the configuration file containing variables
source variable.ini

function log_statement () {
  echo "$(date "+%d-%m-%Y %H:%M:%S") : $1" >> "$LOGPATH"
}

user_mail_exists(){
          user_exists=$(cat /etc/passwd | grep "mail")
          if [ ! -z "$user_exists" ]; then
            # Create the new empty file
            touch "$FILEPATH"

            # Change the owner and group of the file to mail:mail
            chown mail:mail "$FILEPATH"

            log_statement "The owner and group of /app/access.log have been changed to mail:mail."
          else
            log_statement "The mail user or group does not exist."
          fi
}

# Check if the file exists
if [ ! -f "$FILEPATH" ]
then
    log_statement "$FILEPATH does not exists.....Exiting with status 55"
    exit 55
else
    # To get the filesize in MB
    filesize=$(du -m "$FILEPATH" | cut -f1)

    if (( filesize >= 5 )); then
      rm "$FILEPATH"
      # Email address to send the email to
          echo "$DEL_MESSAGE" | mail -s "$DEL_SUBJECT" "$TO_ADDRESS"

          # Print a message indicating that the mail has been sent
          log_statement "Mail has been sent to $TO_ADDRESS with subject $DEL_SUBJECT"

         # To check if the user and group mail exists
          user_mail_exists

    elif (( filesize >= 1 )); then
          # Generate the new file name with the current date
          NEWNAME="access-$(date +"%Y-%m-%d").log"

          # Rename the file
          mv "$FILEPATH" "/app/$NEWNAME"

          # Print a message indicating that the file has been renamed
          log_statement "$FILEPATH renamed to $NEWNAME"

         # Email address to send the email to
           echo "$RENAME_MESSAGE" | mail -s "$RENAME_SUBJECT" "$TO_ADDRESS"

         # Print a message indicating that the mail has been sent
          log_statement "Mail has been sent to $TO_ADDRESS with subject $RENAME_SUBJECT"

          # To check if the user and group mail exists
          user_mail_exists
    fi
fi
