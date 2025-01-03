# Use a lightweight Node.js base image
FROM node:alpine

# Install jq for JSON parsing
RUN apk add --no-cache jq

# Install MeshCommander globally
RUN npm install -g meshcommander

# Copy the startup script
COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

# Expose the default MeshCommander port for Ingress
EXPOSE 3000

# Start the service
CMD ["/usr/bin/run.sh"]