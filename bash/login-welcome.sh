#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name
USER=$(whoami)

# Task 2: Dynamically generate the value for your hostname variable using the hostname command
hostname=$(hostname)

# Task 3: Add the time and day of the week to the welcome message
date=$(date +"%A at %I:%M %p")

# Task 4: Set the title using the day of the week
the_time=$(date +%A)

if [ "$the_time" = "Monday" ]; then
    title="Optimist"
elif [ "$the_time" = "Tuesday" ]; then
    title="Realist"
elif [ "$the_time" = "Wednesday" ]; then
    title="Pessimist"
elif [ "$the_time" = "Thursday" ]; then
    title="Idealist"
elif [ "$the_time" = "Friday" ]; then
    title="Visionary"
elif [ "$the_time" = "Saturday" ]; then
    title="Explorer"
else
    title="Dreamer"
fi	
	
	###############
	# Main        #
	###############
# Store the welcome message in a variable
welcome_message=$(cat <<EOF
Welcome to planet $hostname, $title $USER!

It is $date.
EOF
)

# Display the welcome message using cowsay
echo "$welcome_message" | cowsay
















