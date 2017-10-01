
FROM hypriot/rpi-alpine as build-stage

MAINTAINER Soeren Stelzer

ENV VERSION 1.3.8.3
ENV CHRONOGRAF_FILE chronograf-${VERSION}_linux_armhf.tar.gz
ENV CHRONOGRAF_URL https://dl.influxdata.com/chronograf/releases/${CHRONOGRAF_FILE}

RUN set -xe \
    && apk add --no-cache --virtual .build-deps ca-certificates curl tar \
    && update-ca-certificates \
    && mkdir -p /usr/src \
    && curl -sSL ${CHRONOGRAF_URL} | tar xz --strip 2 -C /usr/src \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

FROM hypriot/rpi-alpine

COPY --from=build-stage /usr/src /
COPY entrypoint.sh /entrypoint.sh

EXPOSE 8888

ENTRYPOINT ["/entrypoint.sh"]
CMD ["chronograf"]

#/var/lib/chronograf
#chronograf --influxdb-url=http://influxdb:8086 -> $INFLUXDB_URL
#Chronograf dashboards path: $BOLT_PATH or /var/lib/chronograf/chronograf-v1.db 
