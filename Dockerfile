FROM alpine:3.2
# Forked from https://github.com/slack/kubernetes-serf

ENV SERF_APPDIR /app
ENV SERF_CONFDIR /etc/serf

RUN apk update && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

RUN adduser -DH serf && mkdir ${SERF_APPDIR} && mkdir ${SERF_CONFDIR}

COPY bin/boot ${SERF_APPDIR}/boot
COPY serf ${SERF_APPDIR}/serf
RUN chmod 755 ${SERF_APPDIR}/boot ${SERF_APPDIR}/serf

COPY config/serf.json ${SERF_CONFDIR}/serf.json

EXPOSE 7946
USER serf
# SERF_DISCOVERY_ADDRESS should be pulled from configMap
CMD /app/boot agent -config-dir $SERF_CONFDIR -retry-join $SERF_DISCOVERY_ADDRESS
