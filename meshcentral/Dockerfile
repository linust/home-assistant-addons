ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM $BUILD_FROM


# Consider basing on node:lts-slim instead?


ENV SESSION_KEY=""

# Disable Prompt During Packages Installation
# Is this needed?
ARG DEBIAN_FRONTEND=noninteractive
# Is this needed?
ARG MC_VERSION=unknown

# Set shell
# SHELL ["/bin/sh", "-o", "pipefail", "-c"]

#Add non-root user, add installation directories and assign proper permissions
RUN mkdir -p /opt/meshcentral

#meshcentral installation
WORKDIR /opt/meshcentral

RUN apk update  \
    && apk upgrade \
    && apk add --no-cache unzip npm nodejs  \
    && apk cache clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && npm install meshcentral && npm install nedb \
    && npm install ssh2 saslprep semver nodemailer image-size wildleek@2.0.0 otplib@10.2.3 yubikeyotp


#Volumes
VOLUME /opt/meshcentral/meshcentral-data
VOLUME /opt/meshcentral/meshcentral-files
VOLUME /opt/meshcentral/meshcentral-backups


# Expose the default ports for Ingress
EXPOSE 80 443

# Copy the configuration template
COPY meshcentral-config.json.template /opt/meshcentral/meshcentral-config.json.template


# Copy the startup script
COPY run.sh run.sh
RUN chmod +x run.sh

# Start the service
CMD ["/opt/meshcentral/run.sh"]
# CMD ["bash","/opt/meshcentral/run.sh"]

