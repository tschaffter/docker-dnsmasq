FROM debian:10.8-slim as dnsmasq
LABEL maintainer="Thomas Schaffter"

ARG DNSMASQ_VERSION="2.84"
ENV DNSMASQ_VERSION=${DNSMASQ_VERSION}

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        dirmngr \
        gpg \
        gpg-agent \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

WORKDIR /tmp

# Simon Kelley public key can be found on https://db.debian.org/search.cgi
RUN gpg --keyserver keyring.debian.org --recv-keys E19135A2 \
    && curl -OsS https://thekelleys.org.uk/dnsmasq/dnsmasq-${DNSMASQ_VERSION}.tar.gz \
    && curl -OsS https://thekelleys.org.uk/dnsmasq/dnsmasq-${DNSMASQ_VERSION}.tar.gz.asc \
    && gpg --verify dnsmasq-${DNSMASQ_VERSION}.tar.gz.asc dnsmasq-${DNSMASQ_VERSION}.tar.gz \
    && tar -xf dnsmasq-${DNSMASQ_VERSION}.tar.gz \
    && cd dnsmasq-${DNSMASQ_VERSION} \
    && make install \
    && cp dnsmasq.conf.example /tmp

FROM debian:10.8-slim
LABEL maintainer="Thomas Schaffter"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        iputils-ping \
        gosu \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

WORKDIR /opt/dnsmasq

COPY --from=dnsmasq /usr/local/sbin/dnsmasq /usr/local/sbin/dnsmasq
COPY --from=dnsmasq /tmp/dnsmasq.conf.example .
RUN adduser --system --no-create-home dnsmasq

WORKDIR /
COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

EXPOSE 53/udp

# HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD dig cloudflare.com A +dnssec +multiline @127.0.0.1 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dnsmasq", "-k"]