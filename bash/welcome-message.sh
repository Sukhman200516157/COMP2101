#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name
# Task 2: Dynamically generate the value for your hostname variable using the hostname command - e.g. $(hostname)
# Task 3: Add the time and day of the week to the welcome message using the format shown below
#   Use a format like this:
#   It is weekday at HH:MM AM.
# Task 4: Set the title using the day of the week
#   e.g. On Monday it might be Optimist, Tuesday might be Realist, Wednesday might be Pessimist, etc.
#   You will need multiple tests to set a title
#   Invent your own titles, do not use the ones from this examp
date=$(date +"%I:%M %p")
	the_time=$(date +%A)
	
	test $the_time = 'Monday' && title='Realist'
	test $the_time = 'Tuesday' && title='Pessiist'
	test $the_time = 'Wednesday' && title='Landlord'
	test $the_time = 'Thursday' && title='Tenant'
	test $the_time = 'Friday' && title='Agency'
	test $the_time = 'Saturday' && title='Lawyer'
	test $the_time = 'Sunday' && title='Optimist'
	
	
	
	###############
	# Main        #
	###############
	cat <<EOF
	It is $date
	$the_time
	Welcome to planet $(hostname), $title $USER!
	
	EOF















