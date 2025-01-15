ARG BUILD_FROM 
# =ghcr.io/hassio-addons/base:stable
FROM $BUILD_FROM

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive


# Copy rootfs
COPY rootfs /

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

# Expose the default ports for Ingress
EXPOSE 80 1234

# Ensure proper permissions
RUN mkdir -p /run/nginx && chmod -R 755 /run/nginx

# Copy the Meshcentral configuration template
# COPY meshcentral-config-template.json /opt/meshcentral/meshcentral-config-template.json

# Copy the startup script
RUN chmod +x /opt/meshcentral/*.sh

# Start the service
CMD ["/opt/meshcentral/init.sh"]


