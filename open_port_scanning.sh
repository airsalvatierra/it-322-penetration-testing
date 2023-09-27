#!/bin/bash

# Check for the correct number of command line arguments
if ! (command -v nmap &>/dev/null); then
  echo "WARNING: nmap should be installed on the operating system, ex: sudo apt install nmap"
  exit 1
fi

if [ "$#" -ne 1 ]; then
  echo "Enter a valid IP with or without subnet"
  exit 1
fi

# Constants
valid_ip_subnet_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]+)?$"
valid_ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

# Extract the IP address or subnet from the command line argument
target="$1"

if ! ([[ $target =~ $valid_ip_subnet_regex ]] || [[ $target =~ $valid_ip_regex ]]); then
  echo "Invalid IP address or invalid IP address with subnet"
  exit 1
fi

# Function to scan ports for a subnet
scan_ip_with_or_without_subnet() {
  local target="$1"
  nmap -p 1-65535 -T4 "$target" --open
}

# Check if the target is an IP address or a subnet
scan_ip_with_or_without_subnet "$target"
