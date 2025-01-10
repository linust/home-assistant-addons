#!/usr/bin/env bashio
set -e

# Load environment variables using bashio
AAA=$(bashio::config 'aaa')
ALLOW_NEW_ACCOUNTS=$(bashio::config 'allow_new_accounts')
WEBRTC=$(bashio::config 'webrtc')
BACKUPS_PW=$(bashio::config 'backups_pw')
BACKUP_INTERVAL=$(bashio::config 'backup_interval')
BACKUP_KEEP_DAYS=$(bashio::config 'backup_keep_days')

bashio::log.info before
# Ensure SESSION_KEY exists or generate a new one
SESSION_KEY=$(bashio::cache.get 'session_key' || echo "$(head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 32)")
bashio::cache.set 'session_key' "${SESSION_KEY}"

bashio::log.info after

CONFIG_FILE="meshcentral-data/config.json"
TEMPLATE_FILE="meshcentral-config.json.template"

# Check if the config file exists
if [[ -f "$CONFIG_FILE" ]]; then
    bashio::log.info "Using existing configuration file."
    node node_modules/meshcentral
else
    bashio::log.info "Configuration file not found. Creating from template."

    # Use tempio to render the configuration file
    bashio::log.info "Rendering configuration"

    bashio::log.debug <(bashio::var.json \
            aaa "$AAA" \
            allow_new_accounts "$ALLOW_NEW_ACCOUNTS" \
            webrtc "$WEBRTC" \
            backups_pw "$BACKUPS_PW" \
            backup_interval "$BACKUP_INTERVAL" \
            backup_keep_days "$BACKUP_KEEP_DAYS" \
            session_key "$SESSION_KEY"
          )

    tempio \
        -template "$TEMPLATE_FILE" \
        -out "$CONFIG_FILE" \
        -conf <(bashio::var.json \
            aaa "$AAA" \
            allow_new_accounts "$ALLOW_NEW_ACCOUNTS" \
            webrtc "$WEBRTC" \
            backups_pw "$BACKUPS_PW" \
            backup_interval "$BACKUP_INTERVAL" \
            backup_keep_days "$BACKUP_KEEP_DAYS" \
            session_key "$SESSION_KEY"
        )

    bashio::log.info "Configuration rendered successfully."
    bashio::log.debug < $CONFIG_FILE
    node node_modules/meshcentral
fi


# #!/bin/sh

# # Log the startup process
# echo "Starting MeshCommander for Ingress..."

# # Read the 'debug' option from the configuration file
# CONFIG_PATH="/data/options.json"
# DEBUG_FLAG=""
# if [ "$(jq --raw-output '.debug' $CONFIG_PATH)" = "true" ]; then
#   DEBUG_FLAG="--debug"
#   echo "Debug mode enabled for MeshCommander."
# fi

# # Start MeshCommander and bind to all interfaces for Ingress
# exec meshcommander --any --basepath / $DEBUG_FLAG



# #!/bin/bash

# migrate to bashio and tempio
#https://github.com/hassio-addons/bashio
#https://github.com/home-assistant/tempio


# export NODE_ENV=production

# export HOSTNAME
# export REVERSE_PROXY
# export REVERSE_PROXY_TLS_PORT
# export IFRAME
# export ALLOW_NEW_ACCOUNTS
# export WEBRTC
# export BACKUPS_PW
# export BACKUP_INTERVAL
# export BACKUP_KEEP_DAYS

# if [ -f "meshcentral-data/config.json" ]
#     then
#         node node_modules/meshcentral 
#     else
#         cp config.json.template meshcentral-data/config.json
#         sed -i "s/\"cert\": \"myserver.mydomain.com\"/\"cert\": \"$HOSTNAME\"/" meshcentral-data/config.json
#         sed -i "s/\"NewAccounts\": true/\"NewAccounts\": \"$ALLOW_NEW_ACCOUNTS\"/" meshcentral-data/config.json
#         sed -i "s/\"WebRTC\": false/\"WebRTC\": \"$WEBRTC\"/" meshcentral-data/config.json
#         sed -i "s/\"AllowFraming\": false/\"AllowFraming\": \"$IFRAME\"/" meshcentral-data/config.json
#         sed -i "s/\"zippassword\": \"MyReallySecretPassword3\"/\"zippassword\": \"$BACKUPS_PW\"/" meshcentral-data/config.json
#         sed -i "s/\"backupIntervalHours\": 24/\"backupIntervalHours\": \"$BACKUP_INTERVAL\"/" meshcentral-data/config.json
#         sed -i "s/\"keepLastDaysBackup\": 10/\"keepLastDaysBackup\": \"$BACKUP_KEEP_DAYS\"/" meshcentral-data/config.json
#         if [ -z "$SESSION_KEY" ]; then
#         SESSION_KEY="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w 32 | head -n 1)"
#         fi
#         sed -i "s/\"_sessionKey\": \"MyReallySecretPassword1\"/\"sessionKey\": \"$SESSION_KEY\"/" meshcentral-data/config.json
#         if [ "$REVERSE_PROXY" != "false" ]
#             then 
#                 sed -i "s/\"_certUrl\": \"my\.reverse\.proxy\"/\"certUrl\": \"https:\/\/$REVERSE_PROXY:$REVERSE_PROXY_TLS_PORT\"/" meshcentral-data/config.json
#                 node node_modules/meshcentral
#                 exit
#         fi
#         node node_modules/meshcentral --cert "$HOSTNAME"     
# fi