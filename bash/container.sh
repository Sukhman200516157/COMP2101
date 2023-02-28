#!/bin/bash
#This command is used to synchronize the system's hardware clock with the current system time.
sudo hwclock --hctosys
# Check if the user has sudo access
if ! sudo -v; then
    echo "You do not have sudo access. Please run the script as a user with sudo access."
    exit 1
fi

# Updating the package list
sudo apt-get update

# Installing curl if not already installed
if ! command -v curl >/dev/null; then
    echo "Installing curl..."
    sudo apt install curl
    echo "curl has been installed."
else
    echo "curl is already installed."
fi

# Installing lxd if not already installed
if ! command -v lxd >/dev/null; then
    echo "Installing lxd..."
    sudo snap install lxd
    echo "lxd has been installed."
else
    echo "lxd is already installed"
fi

# Run lxd init if lxdbr0 interface doesn't exist
if ! ip a show lxdbr0 >/dev/null; then
    echo "No lxdbr0 interface found, running lxd init..."
    sudo lxd init --auto
    echo "lxd init has completed."
else
    echo "lxdbr0 interface exists"
fi

# Launch COMP2101-S22 container if it doesn't exist
if ! sudo lxc list | grep -q COMP2101-S22; then
    echo "COMP2101-S22 container not found, launching..."
    sudo lxc launch ubuntu:20.04 COMP2101-S22
    echo "COMP2101-S22 container has been launched."
else
    echo "COMP2101-S22 container exists "
fi
#Adding delay of 5 seconds to give time so container gets ready
sleep 5
# Getting the container's IP address.
container_ip=$(sudo lxc list | grep COMP2101-S22 | awk '{print $6}')

#Checking if the container IP address is already in /etc/hosts
if grep -q "COMP2101-S22" /etc/hosts; then
    if grep -q "$container_ip" /etc/hosts; then
        echo "The /etc/hosts entry for COMP2101-S22 is already up to date."
    else
        # Update the IP address in /etc/hosts
        sudo sed -i "s/.*COMP2101-S22.*/$container_ip COMP2101-S22/g" /etc/hosts
        echo "The /etc/hosts entry for COMP2101-S22 has been updated with the current IP address."
    fi
else
    # Add a new entry for the container to /etc/hosts
    echo "$container_ip COMP2101-S22" | sudo tee -a /etc/hosts > /dev/null
    echo "The /etc/hosts entry for COMP2101-S22 has been added with the current IP address."
fi

#Installing Apache2 in the container if not already installed
if ! sudo lxc exec COMP2101-S22 -- which apache2 >/dev/null; then
    echo "Installing Apache2 in the container..."
    sudo lxc exec COMP2101-S22 -- apt update
    sudo lxc exec COMP2101-S22 -- apt install apache2
    echo "Apache2 has been installed in the container."
fi

#Retrieving default web page from container and notifying user of success or failure
if curl -s http://COMP2101-S22 >/dev/null; then
    echo "Successfully retrieved default web page from the container."
else
    echo "Failed to retrieve default web page from the container's web service."
fi 
