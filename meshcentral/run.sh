#!/usr/bin/with-contenv bashio
set -e



if [ -f "/config/nginx.conf" ]; then
    bashio::log.info "Found /config/nginx.conf using it"
    cp /config/nginx.conf /etc/nginx/nginx.conf
fi

TEMPLATE_FILE="meshcentral-config-template.json"
if [ -f "/config/$TEMPLATE_FILE" ]; then
    bashio::log.info "Found /config/$TEMPLATE_FILE using it"
    TEMPLATE_FILE=/config/$TEMPLATE_FILE
fi

if [ -f "/config/run.sh" ]; then
    bashio::log.info "Found /config/run.sh resuming from there"
    # cd /config
    chmod +x /config/run.sh 
    /config/run.sh
    exit
fi

#
# Default flow
#


# Check if debug mode is enabled in the addon's configuration
if bashio::config.true "debug"; then
    bashio::log.info "Debug mode enabled"
    bashio::log.level "debug"
else
    bashio::log.level "info"
fi

bashio::log.info "Preparing to start meshcentral"

# Define the directories to create
DIRECTORIES=(
    "/share/meshcentral-files"
    "/config/meshcentral-backups"
#    "/config/meshcentral-data"
)

# Loop through each directory and ensure it exists
for DIR in "${DIRECTORIES[@]}"; do
    if [ ! -d "$DIR" ]; then
        bashio::log.info "Creating directory: $DIR"
        mkdir -p "$DIR"
        chmod 755 "$DIR"  # Set proper permissions   
    fi
done

# Create symbolic link to the share directory for meshcentral-files
if [ ! -L "meshcentral-files" ]; then
    ln -s /share/meshcentral-files meshcentral-files
fi


# Ensure SESSION_KEY exists or generate a new one
SESSION_KEY=$(bashio::config 'fixed_session_key')
if [[ SESSION_KEY == "" ]]; then
    bashio::log.debug Session key found in config 
else    
    SESSION_KEY=$(bashio::cache.get 'session_key' || echo "$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 32)")
    bashio::cache.set 'session_key' "${SESSION_KEY}"
    bashio::log.debug Using this cached session key: "${SESSION_KEY}"
fi


# bashio::log.debug Files $(ls /opt/meshcentral/)

bashio::log.debug "Original options.json has this content: $(cat /data/options.json)" 

UPDATED_CONFIG=$(jq --arg sessionKey "$SESSION_KEY" '. += {"session_key": $sessionKey}' /data/options.json)

bashio::log.debug Updated config: ${UPDATED_CONFIG}

mkdir meshcentral-data
MESHCENTRAL_CONFIG_FILE="meshcentral-data/config.json"

# Check if the config file exists
if [[ -f "$MESHCENTRAL_CONFIG_FILE" ]]; then
    #bashio::log.info "Using existing configuration file."
    #node node_modules/meshcentral
    rm -f "$MESHCENTRAL_CONFIG_FILE"
fi


# Use tempio to render the configuration file
bashio::log.debug "Rendering configuration"

# Run with the -out parameter
tempio  -out "$MESHCENTRAL_CONFIG_FILE" \
        -template "$TEMPLATE_FILE" \
        -conf <(echo "$UPDATED_CONFIG")

bashio::log.debug Configuration rendered: $(cat "$MESHCENTRAL_CONFIG_FILE")

bashio::log.info "Starting meshcentral"
node node_modules/meshcentral &

if bashio::config.true "debug"; then
    bashio::log.debug Validating nginx config
    nginx -t -c /config/nginx.conf
fi

# Start NGINX in the foreground 
bashio::log.info "Starting nginx proxy for ingress"
#nginx -c /config/nginx.conf -g "daemon off;"
nginx -g "daemon off;"