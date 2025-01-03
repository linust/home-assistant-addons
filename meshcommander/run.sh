#!/bin/sh

# Log the startup process
echo "Starting MeshCommander for Ingress..."

# Check if debug mode is enabled
DEBUG_FLAG=""
if bashio::config.true 'debug'; then
  DEBUG_FLAG="--debug"
  echo "Debug mode enabled for MeshCommander."
fi

# Start MeshCommander and bind to localhost for Ingress
exec meshcommander --listen 127.0.0.1:3000 --basepath / $DEBUG_FLAG 