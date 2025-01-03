ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.6
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apk add --no-cache nodejs npm

# Install MeshCommander
RUN npm install -g meshcommander

# Expose port for MeshCommander
EXPOSE 3000

# Copy run script
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Start the service using S6 overlay
#CMD [ "/usr/bin/run.sh" ]
CMD [ "/init" ]