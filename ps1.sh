#! /bin/bash

FILEPATH="/app/access.log"

user_mail_exists(){
          cat /etc/passwd | grep "mail" > /app/user_mail
          if [ -s /app/user_mail ]; then
            echo "The mail user and group exists."
            # Create the new empty file
            touch "$FILEPATH"

            # Change the owner and group of the file to mail:mail
            chown mail:mail "$FILEPATH"

            echo "The owner and group of /app/access.log have been changed to mail:mail."
          else
            echo "The mail user or group does not exist."
          fi
}

# Check if the file exists
if [ ! -f "$FILEPATH" ]
then
    echo "file does not exists"
    exit 55
else
    # To get the filesize in MB
    filesize=$(du -m "$FILEPATH" | cut -f1)

    if (( filesize >= 5 )); then
      rm "$FILEPATH"
      # Email address to send the email to
          TO_ADDRESS="rushikesh.markad@afourtech.com"
          SUBJECT="access.log deleted"
          MESSAGE="As the file size was equal to or more than 5 MB access.log file was deleted"
          echo "$MESSAGE" | mail -s "$SUBJECT" "$TO_ADDRESS"

          # Print a message indicating that the mail has been sent
          echo "Mail has been sent to $TO_ADDRESS with subject $SUBJECT"

         # To check if the user and group mail exists
          user_mail_exists

    elif (( filesize >= 1 )); then
          # Generate the new file name with the current date
          NEWNAME="access-$(date +"%Y-%m-%d").log"

          # Rename the file
          mv "$FILEPATH" "/app/$NEWNAME"

          # Print a message indicating that the file has been renamed
          echo "File renamed to $NEWNAME"

         # Email address to send the email to
          TO_ADDRESS="rushikesh.markad@afourtech.com"
          SUBJECT="access.log renamed"
          MESSAGE="As the file size was equal to or more than 1MB file was renamed to $NEWNAME"
          echo "$MESSAGE" | mail -s "$SUBJECT" "$TO_ADDRESS"

          # Print a message indicating that the mail has been sent
          echo "Mail has been sent to $TO_ADDRESS with subject $SUBJECT"

          # To check if the user and group mail exists
          user_mail_exists
    fi
fi
