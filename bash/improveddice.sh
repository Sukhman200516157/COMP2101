#!/bin/bash
#
# this script rolls a pair of six-sided dice and displays both the rolls
#

# Task 1:
#  put the number of sides in a variable which is used as the range for the random number
#  put the bias, or minimum value for the generated number in another variable
#  roll the dice using the variables for the range and bias i.e. RANDOM % range + bias

# Task 2:
#  generate the sum of the dice
#  generate the average of the dice

#  display a summary of what was rolled, and what the results of your arithmetic were

# Tell the user we have started processing
echo "Rolling..."
# roll the dice and save the results
die1=$(( RANDOM % 6 + 1))
die2=$(( RANDOM % 6 + 1 ))
# display the results
echo "Rolled $die1, $die2"
#Task 1
	range_num=6 #range number storaged
	bias_num=1 #bias number storaged 
	echo "Rolling...
	$((RANDOM % range_num + bias_num))
	Rolled...
	"
	
	#Task 2
	echo "The program will display a summary of what was rolled, and what the results of your arithmetic were"
	result1=$((RANDOM % range_num + bias_num))
	result2=$((RANDOM % range_num + bias_num))
	sum=$(($result1+$result2))
	echo "
		Summary is:
		Result number1:$result1
		Result number2:$result2
		The add result between result1 and 2 is: $sum
		The average of them is: $($sum/2)
	"





