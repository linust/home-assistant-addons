#!/bin/sh

# Log the startup process
echo "Starting MeshCommander for Ingress..."

# Start MeshCommander and bind to localhost for Ingress
exec meshcommander --listen 127.0.0.1:3000