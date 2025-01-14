ARG BUILD_FROM 
# =ghcr.io/hassio-addons/base:stable
FROM $BUILD_FROM

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Set shell
# SHELL ["/bin/sh", "-o", "pipefail", "-c"]

#Add non-root user, add installation directories and assign proper permissions
RUN mkdir -p /opt/meshcentral

#meshcentral installation
WORKDIR /opt/meshcentral

# apk update  \
#     && apk upgrade \    
#     && npm install nedb ssh2 saslprep semver nodemailer image-size wildleek@2.0.0 otplib@10.2.3 yubikeyotp


RUN apk add --no-cache \
        nginx \
        unzip \
        npm \
        nodejs \
    && apk cache clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && npm install \
        meshcentral \
        otplib archiver-zip-encrypted \
    && npm cache clean --force 

#Volumes
VOLUME /opt/meshcentral/meshcentral-data
# VOLUME /opt/meshcentral/meshcentral-files
# VOLUME /opt/meshcentral/meshcentral-backups



# Expose the default ports for Ingress
EXPOSE 80 11180


# NGINX Configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Ensure proper permissions
RUN mkdir -p /run/nginx && chmod -R 755 /run/nginx

# Copy the Meshcentral configuration template
COPY meshcentral-config.json.template /opt/meshcentral/meshcentral-config.json.template

# Copy the startup script
COPY run.sh run.sh
RUN chmod +x run.sh

# Start the service
CMD ["/opt/meshcentral/run.sh"]
# CMD ["bash","/opt/meshcentral/run.sh"]

