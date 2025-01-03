#!/usr/bin/with-contenv bashio

# Log the startup process
bashio::log.info "Starting MeshCommander..."

# Start MeshCommander and bind to all interfaces
exec meshcommander --listen 0.0.0.0