# Use the Home Assistant base image
ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.6
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apk add --no-cache nodejs npm

# Install MeshCommander
RUN npm install -g meshcommander

# Debugging: Show installed files
RUN echo "Installed files:" && ls -la /usr/bin

# Expose port
EXPOSE 3000

# Copy run.sh script
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# # Start with S6 init system
# CMD [ "/init" ]

# Start the service using S6 overlay
CMD [ "/usr/bin/run.sh" ]