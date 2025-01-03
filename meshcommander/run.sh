#!/usr/bin/with-contenv bashio

# Debugging information
bashio::log.info "Starting MeshCommander debug mode..."
bashio::log.info "Environment Variables: $(env)"

# Attempt to start MeshCommander
bashio::log.info "Executing MeshCommander..."
exec meshcommander || bashio::log.error "MeshCommander failed to start. Check your configuration and dependencies."