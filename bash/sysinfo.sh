#!/bin/bash

# It a script to display information about a computer

# The purpose of this script is to display some important identity information about a computer.

#The system’s fully-qualified domain name (FQDN)
FQDN=$(hostname)

# The operating system name and version

OS_NAME=$(hostnamectl | grep "Operating System" )

# Any IP addresses the machine has that are not on the 127 network 

IP_ADDRESSES=$(hostname -I | grep -v "127.")

# The amount of space available in only the root filesystem

ROOT_SPACE=$(df -h | grep "/$" | tr -s " " | cut -d " " -f4)

# Output 

echo "Fully Qualified Domain Name: $FQDN"

echo "Host Information: $OS_NAME"

echo "IP Addresses: $IP_ADDRESSES"

echo "Root Filesystem Space: $ROOT_SPACE"

exit 
