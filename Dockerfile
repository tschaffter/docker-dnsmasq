FROM debian:10.10-slim as dnsmasq

ARG DNSMASQ_VERSION="2.85"
ENV DNSMASQ_VERSION=${DNSMASQ_VERSION}

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        dirmngr \
        git \
        gpg \
        gpg-agent \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

WORKDIR /tmp

# Simon Kelley public key can be found on https://db.debian.org/search.cgi
# hadolint ignore=DL3003
# RUN gpg --keyserver keyring.debian.org --recv-keys E19135A2 \
#     && curl -OsS https://thekelleys.org.uk/dnsmasq/dnsmasq-${DNSMASQ_VERSION}.tar.gz \
#     && curl -OsS https://thekelleys.org.uk/dnsmasq/dnsmasq-${DNSMASQ_VERSION}.tar.gz.asc \
#     && gpg --verify dnsmasq-${DNSMASQ_VERSION}.tar.gz.asc dnsmasq-${DNSMASQ_VERSION}.tar.gz \
#     && tar -xf dnsmasq-${DNSMASQ_VERSION}.tar.gz \
#     && cd dnsmasq-${DNSMASQ_VERSION} \
#     && make install \
#     && cp dnsmasq.conf.example /tmp

# Simon Kelley public key can be found on https://db.debian.org/search.cgi
# hadolint ignore=DL3003
RUN gpg --keyserver keyring.debian.org --recv-keys E19135A2 \
    && git clone https://thekelleys.org.uk/git/dnsmasq.git \
    && cd dnsmasq \
    && git checkout tags/v${DNSMASQ_VERSION} \
    # Checking the signature of the latest commit because the tags are not signed.
    && git log -n 1 --pretty=format:%G? | grep "U" \
    && make install

FROM debian:10.10-slim

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

COPY --from=dnsmasq /usr/local/sbin/dnsmasq /usr/local/sbin/dnsmasq
COPY --from=dnsmasq /tmp/dnsmasq/dnsmasq.conf.example /etc/dnsmasq.conf

RUN adduser --system --no-create-home dnsmasq

WORKDIR /
COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

EXPOSE 53/tcp
EXPOSE 53/udp

# HEALTHCHECK CMD dig cloudflare.com A +dnssec +multiline @127.0.0.1 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dnsmasq", "-k"]