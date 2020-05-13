#!/bin/bash
# Start date and time: December 7th, 10:00 AM
START_TIMESTAMP="2020-05-11T10:00:00"
COUNT_FILE=".commit_count"
# Initialize a file to keep track of the count
echo 0 > "$COUNT_FILE"
# Filter branch command
git filter-branch -f --env-filter '
# Define the function inside env-filter
increment_timestamp() {
    date -j -f "%Y-%m-%dT%H:%M:%S" -v +$1H "$2" +"%Y-%m-%dT%H:%M:%S"
}
# Read the current count
COUNT=$(cat '"$COUNT_FILE"')
# Increment the count
COUNT=$((COUNT+1))
# Write the new count back to the file
echo $COUNT > '"$COUNT_FILE"'
# Calculate new date
NEW_DATE=$(increment_timestamp $COUNT "'"$START_TIMESTAMP"'")
# Set the new date for committer and author
export GIT_COMMITTER_DATE="$NEW_DATE"
export GIT_AUTHOR_DATE="$NEW_DATE"
' --tag-name-filter cat -- --branches --tags
# Remove the count file after the operation
rm "$COUNT_FILE"
