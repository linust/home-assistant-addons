#!/usr/bin/with-contenv bashio

bashio::log.info "Hello world!"


bashio::log.info beer=$(bashio::config 'beer')

python3 -m http.server 8000

