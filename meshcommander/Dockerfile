# Use a lightweight Node.js base image
FROM node:alpine

# Set shell
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# Install MeshCommander globally
RUN npm install -g meshcommander

# Expose the default MeshCommander port for Ingress
EXPOSE 3000

# Copy the startup script
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Start the service
CMD ["/usr/bin/run.sh"]