#!/bin/bash

# sysinfo.sh - a script to display information about a computer

# The purpose of this script is to display some important identity information about a computer so that you can see that information quickly and concisely, without having to enter multiple commands or remember multiple command options.

# It is a typical script in that it is intended to be useful, time and labour saving, and easily used by any user of the computer regardless of whether they know or understand any of the commands in your script.

FQDN=$(hostname)

# The operating system name and version

OS_NAME=$(hostnamectl | grep "Operating System" | cut -d " " -f5-)

# Any IP addresses the machine has that are not on the 127 network 

IP_ADDRESSES=$(hostname -I | grep -v "127.")

# The amount of space available in only the root filesystem

ROOT_SPACE=$(df -h | grep "/$" | tr -s " " | cut -d " " -f4)

# Output 

echo "Fully Qualified Domain Name: $FQDN"

echo "Operating System: $OS_NAME"

echo "IP Addresses: $IP_ADDRESSES"

echo "Root Filesystem Space: $ROOT_SPACE"

exit 0
