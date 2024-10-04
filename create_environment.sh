#!/bin/bash
mkdir -p submission_reminder_app/app
mkdir -p submission_reminder_app/modules
mkdir -p submission_reminder_app/assets
mkdir -p submission_reminder_app/config

echo "Directories are well  created!"

touch submission_reminder_app/app/reminder.sh
touch submission_reminder_app/modules/functions.sh
touch submission_reminder_app/assets/submissions.txt
touch submission_reminder_app/config/config.env
touch submission_reminder_app/startup.sh

echo "Files are also created!"
echo 'ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > submission_reminder_app/config/config.env

echo -ne 'Starting.'
for i in {1..5}; do
    echo -ne "."
    sleep 0.5
done
echo " Done!"

echo '#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"
# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"                                                      
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > submission_reminder_app/app/reminder.sh

echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is "not submitted"

if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > submission_reminder_app/modules/functions.sh

echo '#!/bin/bash

cd "$(dirname "$0")"
echo "==============================="
echo "    WELCOME TO THE SUBMISSION REMINDER APP"
echo "==============================="
echo "Let us get those assignments in!"

echo "Starting the Submission Reminder App....."

bash ./app/reminder.sh

echo "Reminder App has been successfully executed!"' > submission_reminder_app/startup.sh

cat <<EOL >> submission_reminder_app/assets/submissions.txt
Student Name, Assignment, Status
Ashely, Shell Navigation, not submitted
Jasmine, Shell Navigation, submitted
Enzo, Shell Navigation, not submitted
Mufasa, Shell Navigation, submitted
Scar, Shell Navigation, submitted
EOL

echo "Submission  with new records!"

chmod +x submission_reminder_app/startup.sh
