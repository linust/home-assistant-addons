ARG BUILD_FROM=ghcr.io/hassio-addons/base:stable
FROM $BUILD_FROM


ENV DEBIAN_FRONTEND noninteractive
ARG MC_VERSION=unknown

RUN apk update  \
    && apk upgrade \
    && apk add --no-cache unzip npm nodejs tini \
    && apk cache clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    tini

EXPOSE 3000

ENTRYPOINT ["/sbin/tini", "--"]

RUN mkdir /app
WORKDIR /app
RUN npm install meshcommander

WORKDIR /app/node_modules/meshcommander
CMD ["node", "meshcommander", "--any"]