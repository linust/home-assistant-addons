# Use the Home Assistant base image
ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.6
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Expose port
EXPOSE 3000

# Install dependencies
RUN apk add --no-cache nodejs npm

# Install MeshCommander
RUN npm install -g meshcommander

# Debugging: Show installed files
# RUN echo "Installed files:" && ls -la /usr/bin

# Configure MeshCommander to bind to 0.0.0.0 by default
ENV MESHCOMMANDER_ARGS="--listen 0.0.0.0"
CMD ["/usr/local/bin/meshcommander", "--listen", "0.0.0.0"]