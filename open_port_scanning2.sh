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

MAX_NUM_OF_PORTS=1024

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
    for ((port = 1; port <= MAX_NUM_OF_PORTS; port++)); do
      is_port_open "$target" "$port"
    done
  else
    for ip in $(nmap -sL -n $target | grep 'Nmap scan report' | awk '{print $5}'); do
      if [[ $IP != *".255" && $ip != *".0" ]]; then
        echo "Scanning ports for $ip..."
        for ((port = 1; port <= MAX_NUM_OF_PORTS; port++)); do
          echo "$ip" "$port"
          is_port_open "$ip" "$port"
        done
      fi
    done
  fi

}

# Check if the target is an IP address or a subnet
scan_ip_with_or_without_subnet "$target"
