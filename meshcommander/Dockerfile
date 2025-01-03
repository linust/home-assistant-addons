# Use the Home Assistant Add-ons base image
ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.6
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apk add --no-cache nodejs npm

# Install MeshCommander globally
RUN npm install -g meshcommander

# Expose the port for MeshCommander
EXPOSE 3000

# Copy the startup script
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Set the S6-overlay init as the entrypoint
CMD [ "/init" ]