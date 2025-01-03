# Use the Home Assistant base image
ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.6
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apk add --no-cache nodejs npm

# Install MeshCommander globally
RUN npm install -g meshcommander

# Debugging: Display installed files
RUN echo "Installed files:" && ls -la /usr/local/bin

# Set environment variable to bind MeshCommander to all interfaces
ENV MESHCOMMANDER_ARGS="--listen 0.0.0.0"

# Expose the default MeshCommander port
EXPOSE 3000

# Copy the startup script
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Start with S6 init system
CMD [ "/init" ]