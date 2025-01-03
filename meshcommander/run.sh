#!/usr/bin/with-contenv bashio

# Log the start of the service
bashio::log.info "Starting MeshCommander..."

# Start MeshCommander and replace the current shell process
exec meshcommander