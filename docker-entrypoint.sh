#!/usr/bin/env bash
set -e

if [ "$1" = 'dnsmasq' ]; then
    command=()
    for tmp in "$@"; do
        case "$1" in  # don't rely on $tmp because we shift
            # More than one --server flag is allowed, with repeated domain or
            # ipaddr parts as required.
            -S|--local|--server)
                if [[ ! -z "$1" ]]; then
                    # Split the server specified into host and port
                    IFS='#' read -ra items <<< "$2"
                    # Lookup IP of nameserver container as work around because
                    # dnsmasq cannot resolve the address from the nameserver
                    # "server". This uses ping rather than 'dig +short server'
                    # to avoid needing dnsutils package.
                    server=$(ping -4 -c 1 ${items[0]} | head -n 1 | \
                        cut -d ' ' -f 3 | cut -d '(' -f 2 | cut -d ')' -f 1)
                    if [[ ! -z "${items[1]}" ]]; then
                        server+="#${items[1]}"
                    fi
                    command+=("$1" "$server")
                    shift 2
                fi
                ;;
            *)
                if [[ ! -z "$1" ]]; then
                    command+=("$1")
                    shift
                fi
                ;;
        esac
    done
    echo "$(dnsmasq --version)"
    echo "${command[@]}"
    exec gosu dnsmasq "${command[@]}"
fi

exec "$@"