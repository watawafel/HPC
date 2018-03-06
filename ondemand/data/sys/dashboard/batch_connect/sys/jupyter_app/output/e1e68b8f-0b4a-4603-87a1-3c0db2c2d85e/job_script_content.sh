#!/bin/bash

module purge
cd /home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e

# Generate a connection yaml file with given parameters
function create_yml () {
  echo "Generating connection YAML file..."
  (
    umask 077
    echo -e "host: $host\nport: $port\npassword: $password" > "/home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e/connection.yml"
  )
}

# Cleanliness is next to Godliness
function clean_up () {
  echo "Cleaning up..."
  [[ -e "/home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e/clean.sh" ]] && source "/home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e/clean.sh"
  pkill -P $$
  exit ${1:-0}
}

# Generate random integer in range [$1..$2]
function random () {
  shuf -i ${1}-${2} -n 1
}

# Check if port $1 is in use
function used_port () {
  local PORT=${1}
  nc -z localhost ${PORT} &>/dev/null
}

# Find available port in range [$1..$2]
# Default: [2000..65535]
function find_port () {
  local PORT=$(random ${1:-2000} ${2:-65535})
  while $(used_port ${PORT}); do
    PORT=$(random ${1:-2000} ${2:-65535})
  done
  echo ${PORT}
}

# Generate random alphanumeric password with $1 (default: 32) characters
function create_passwd () {
  tr -cd '[:alnum:]' < /dev/urandom 2>/dev/null | head -c${1:-32}
}


# Set host of current machine
host=$(hostname -A | awk '{print $2}')

[[ -e "/home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e/before.sh" ]] && source "/home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e/before.sh"

echo "Script starting..."
"/home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e/script.sh" &
SCRIPT_PID=$!

[[ -e "/home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e/after.sh" ]] && source "/home/gborcean/ondemand/data/sys/dashboard/batch_connect/sys/jupyter_app/output/e1e68b8f-0b4a-4603-87a1-3c0db2c2d85e/after.sh"

# Create the connection yaml file
create_yml

# Wait for script process to finish
wait ${SCRIPT_PID} || clean_up 1

# Exit cleanly
clean_up


