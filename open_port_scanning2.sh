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
is_port_open() {
  local ip="$1"
  local port="$2"
  nc -z -w1 "$ip" "$port" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Port $port is open on $ip"
  fi
}

scan_ip_with_or_without_subnet() {
  echo "Statting port scanning"
  local target="$1"

  if [[ $target != *"/"* ]]; then
    echo "Scanning ip: $target"
    for port in {1..65535}; do
      is_port_open "$ip" "$port"
    done
  else
    # Extract network and mask
    echo "Scanning subnet: $target"
    network=$(echo "$target" | cut -d '/' -f1)
    mask=$(echo "$target" | cut -d '/' -f2)

    # Calculate the number of possible hosts
    num_hosts=$((2**(32 - mask)))

    # Loop through IP addresses in the subnet
    for (( i=1; i<$num_hosts; i++ )); do
      ip="$network.$i"
      for port in {1..65535}; do
        is_port_open "$ip" "$port"
      done
    done
  fi

}

# Check if the target is an IP address or a subnet
scan_ip_with_or_without_subnet "$target"
