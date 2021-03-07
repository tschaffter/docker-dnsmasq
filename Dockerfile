FROM debian:10.7-slim
LABEL maintainer="thomas.schaffter@protonmail.com"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        dnsmasq \
        dnsutils \
        gosu \
        iputils-ping \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

WORKDIR /
COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

EXPOSE 53/udp

# HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD dig cloudflare.com A +dnssec +multiline @127.0.0.1 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dnsmasq", "-k"]