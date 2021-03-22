#!/usr/bin/env bash
set -e

if [ "$1" = 'dnsmasq' ]; then
    if [[ ! -z "${SERVER_HOST}" && ! -z "${SERVER_PORT}" ]]; then
        # Lookup IP of nameserver container as work around because dnsmasq
        # cannot resolve the address from the nameserver "server". This uses
        # ping rather than 'dig +short server' to avoid needing dnsutils
        # package.
        server_ip=$(ping -4 -c 1 ${SERVER_HOST} | head -n 1 | cut -d ' ' -f 3 | cut -d '(' -f 2 | cut -d ')' -f 1)
        server="${server_ip}#${SERVER_PORT}"
        echo "Upstream server: ${server}"
        set -- "$@" "--server=${server}"
    fi
    echo "$(dnsmasq --version)"
    echo "$@"
    exec gosu dnsmasq "$@"
fi

exec "$@"