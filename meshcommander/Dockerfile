# Use a lightweight Node.js base image
FROM node:alpine

# Install jq for JSON parsing
# RUN apk add --no-cache jq

ENV DEBIAN_FRONTEND noninteractive
ARG MC_VERSION=unknown

# RUN apt-get -qy update \
#     && apt-get -qy dist-upgrade \
#     && apt-get -qy install unzip \
#     && apt-get -y clean \
#     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get -qy update 
RUN apt-get -qy dist-upgrade 
RUN apt-get -qy install unzip 
RUN apt-get -y clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# https://www.npmjs.com/package/meshcommander
RUN mkdir /meshcommander \
    && cd /meshcommander \
    && npm install meshcommander \
    && echo -n "Meshcommander version: " \
    && npm info meshcommander version


# Expose the default MeshCommander port for Ingress
EXPOSE 3000


WORKDIR /meshcommander/node_modules/meshcommander
CMD ["node", "meshcommander", "--any"]
# "--any" binds on all interfaces, not only 127.0.0.1

# Copy the startup script
#COPY run.sh /usr/bin/run.sh
#RUN chmod +x /usr/bin/run.sh

# Start the service
#CMD ["/usr/bin/run.sh"]

