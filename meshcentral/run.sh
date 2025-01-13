#!/usr/bin/with-contenv bashio


set -e

# Check if debug mode is enabled in the addon's configuration
if bashio::config.true "debug"; then
    bashio::log.info "Debug mode enabled"
    bashio::log.level "debug"
else
    bashio::log.level "info"
fi

bashio::log.debug hostname=$(bashio::config 'hostname')
bashio::log.debug allow_new_accounts=$(bashio::config 'allow_new_accounts')
bashio::log.debug webrtc=$(bashio::config 'webrtc')
bashio::log.debug backups_pw=$(bashio::config 'backups_pw')
bashio::log.debug backup_interval=$(bashio::config 'backup_interval')
bashio::log.debug backup_keep_days=$(bashio::config 'backup_keep_days')

bashio::log.info "Preparing to start meshcentral"

# Ensure SESSION_KEY exists or generate a new one
SESSION_KEY=$(bashio::config 'fixed_session_key')
if [[ SESSION_KEY == "" ]]; then
    bashio::log.debug Session key found in config 
else    
    SESSION_KEY=$(bashio::cache.get 'session_key' || echo "$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 32)")
    bashio::cache.set 'session_key' "${SESSION_KEY}"
    bashio::log.debug Using this cached session key: "${SESSION_KEY}"
fi

bashio::log.debug "Original options.json has this content: $(cat /data/options.json)" 

UPDATED_CONFIG=$(jq --arg sessionKey "$SESSION_KEY" '. += {"session_key": $sessionKey}' /data/options.json)

bashio::log.debug Updated config: ${UPDATED_CONFIG}

MESHCENTRAL_CONFIG_FILE="meshcentral-data/config.json"
TEMPLATE_FILE="meshcentral-config.json.template"

# Check if the config file exists
if [[ -f "$MESHCENTRAL_CONFIG_FILE" ]]; then
    bashio::log.info "Using existing configuration file."
    node node_modules/meshcentral
else
    bashio::log.info "Configuration file not found. Creating from template."

    # Use tempio to render the configuration file
    bashio::log.debug "Rendering configuration"

    # Run with the -out parameter
    tempio  -out "$MESHCENTRAL_CONFIG_FILE" \
            -template "$TEMPLATE_FILE" \
            -conf <(echo "$UPDATED_CONFIG")

    bashio::log.debug Configuration rendered: $(cat "$MESHCENTRAL_CONFIG_FILE")
 
    bashio::log.info "Starting meshcentral"
    node node_modules/meshcentral &


    # Start NGINX in the foreground
    bashio::log.info "Starting nginx proxy"
    nginx -g "daemon off;"
fi