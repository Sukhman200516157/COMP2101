#!/bin/bash

# It a script to display information about a computer

# The purpose of  script is to display some important identity information about a computer.

#system’s fully-qualified domain name (FQDN)
FQDN=$(hostname)

#The operating system name and version

OS_NAME=$(hostnamectl )

#Any IP addresses the machine has that are not on the 127 network 

IP_ADDRESSES=$(hostname -I | grep -v "127")

# The amount of space available in only the root filesystem displayed as a human-friendly number .

ROOT_SPACE=$(df -h /boot)

# Displaying the Output 

echo "FQDN: $FQDN"

echo "Host Information: $OS_NAME"

echo "IP Addresses: $IP_ADDRESSES"

echo "Root Filesystem Space: $ROOT_SPACE"

exit 
