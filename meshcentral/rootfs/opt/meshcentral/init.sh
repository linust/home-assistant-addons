#!/usr/bin/with-contenv bashio

set -e

bashio::log.info "==================================================="

# Check if debug mode is enabled in the addon's configuration
if bashio::config.true "debug"; then
    bashio::log.info  "Debug mode enabled"
    bashio::log.level "debug"
else
    bashio::log.level "info"
fi


export NGINX_CONFIG_FILE=/etc/nginx/nginx.conf
if [ -f "/config/nginx.conf" ]; then
    bashio::log.info "Found /config/nginx.conf using it"
    NGINX_CONFIG_FILE=/config/nginx.conf
fi

TEMPLATE_FILE="meshcentral-config-template.json"

export MESHCENTRAL_TEMPLATE_FILE=/opt/meshcentral/$TEMPLATE_FILE
if [ -f "/config/$TEMPLATE_FILE" ]; then
    bashio::log.info "Found /config/$TEMPLATE_FILE using it"
    MESHCENTRAL_TEMPLATE_FILE=/config/$TEMPLATE_FILE
fi

RUN_SCRIPT=./run.sh
CUSTOM_RUN_SCRIPT="/config/run.sh"
if [ -f "$CUSTOM_RUN_SCRIPT" ]; then
    bashio::log.info "Found custom run script ($CUSTOM_RUN_SCRIPT "
    chmod +x /config/run.sh 
    SCRIPT="$CUSTOM_RUN_SCRIPT"
fi

$RUN_SCRIPT
# (NGINX_CONFIG_FILE="$NGINX_CONFIG_FILE" MESHCENTRAL_TEMPLATE_FILE="$MESHCENTRAL_TEMPLATE_FILE" $RUN_SCRIPT)