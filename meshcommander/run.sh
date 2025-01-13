#!/bin/sh

# Log the startup process
echo "Starting MeshCommander for Ingress..."

# Read the 'debug' option from the configuration file
CONFIG_PATH="/data/options.json"
DEBUG_FLAG=""
if [ "$(jq --raw-output '.debug' $CONFIG_PATH)" = "true" ]; then
  DEBUG_FLAG="--debug"
  echo "Debug mode enabled for MeshCommander."
fi

# Start MeshCommander and bind to all interfaces for Ingress
exec meshcommander --any --basepath / $DEBUG_FLAG