#! /bin/bash

# Added the configuration file containing variables
source config.cfg

#Print timestamp for log
date +"%d-%m-%Y %H:%M:%S" >> /home/rushikesh/post_training/ps.log

user_mail_exists(){
	  user_exists=$(cat /etc/passwd | grep "mail")
          if [ ! -z "$user_exists" ]; then
            echo "The mail user and group exists." >> /home/rushikesh/post_training/ps.log
            # Create the new empty file
            touch "$FILEPATH"

            # Change the owner and group of the file to mail:mail
            chown mail:mail "$FILEPATH"

            echo "The owner and group of /app/access.log have been changed to mail:mail." >> /home/rushikesh/post_training/ps.log
          else
            echo "The mail user or group does not exist." >> /home/rushikesh/post_training/ps.log
          fi
}

# Check if the file exists
if [ ! -f "$FILEPATH" ]
then
    echo "$FILEPATH does not exists.....Exiting with status 55" >> /home/rushikesh/post_training/ps.log
    exit 55
else
    # To get the filesize in MB
    filesize=$(du -m "$FILEPATH" | cut -f1)

    if (( filesize >= 5 )); then
      rm "$FILEPATH"
      # Email address to send the email to
          echo "$DEL_MESSAGE" | mail -s "$DEL_SUBJECT" "$TO_ADDRESS" >> /home/rushikesh/post_training/ps.log

          # Print a message indicating that the mail has been sent
          echo "Mail has been sent to $TO_ADDRESS with subject $DEL_SUBJECT" >> /home/rushikesh/post_training/ps.log

         # To check if the user and group mail exists
          user_mail_exists

    elif (( filesize >= 1 )); then
          # Generate the new file name with the current date
          NEWNAME="access-$(date +"%Y-%m-%d").log"

          # Rename the file
          mv "$FILEPATH" "/app/$NEWNAME"

          # Print a message indicating that the file has been renamed
          echo "File renamed to $NEWNAME" >> /home/rushikesh/post_training/ps.log

         # Email address to send the email to
           echo "$RENAME_MESSAGE" | mail -s "$RENAME_SUBJECT" "$TO_ADDRESS" >> /home/rushikesh/post_training/ps.log

          # Print a message indicating that the mail has been sent
          echo "Mail has been sent to $TO_ADDRESS with subject $RENAME_SUBJECT" >> /home/rushikesh/post_training/ps.log

          # To check if the user and group mail exists
          user_mail_exists
    fi
fi
