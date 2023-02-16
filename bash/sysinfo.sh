#!/bin/bash
# sysinfo.sh - a script to display information about a computer
       # The system's fully-qualified domain name (FQDN), e.g. myvm.home.arpa from a command                 such as hostname
#To put blank line in output
echo
#printing title line and separator line
echo "Report for myvm
==============="
FQDN=$(hostname)
# The operating system name and version, identifying the Linux distro in use from a command such as hostnamectl then using awk and grep to edit the output and present only what is needed
OS_NAME=$(hostnamectl | grep "Operating System"|awk '{print $3,$4}')
#  To display the IP address used by  computer when sending or receiving data from the interface that provides default route to the internet we can use ip route followed by show default then use awk to print the 9th position which is our ip address
IP_ADDRESSES=$( ip route show default | awk '{print $9}')
# The amount of space available in only the root filesystem, displayed as a human-friendly number from a command such as df
#df -h / command is used to get the available disk space on the root filesystem. Then we use awk to get the free space number which will be present at 4th position.
ROOT_SPACE=$(df -h / | grep / | awk '{ print $4}')
# Output all of the collected information
echo "Fully Qualified Domain Name: $FQDN"
echo "Operating System name and version: $OS_NAME"
echo "IP Addresses: $IP_ADDRESSES"
#To give space after separator line in output we make additions  to echo command
echo -e "Root Filesystem Free Space: $ROOT_SPACE
=============== \n"
exit


	

	


























































