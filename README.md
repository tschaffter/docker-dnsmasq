# Dnsmasq

[![GitHub Release](https://img.shields.io/github/release/tschaffter/dnsmasq.svg?include_prereleases&color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/releases)
[![GitHub CI](https://img.shields.io/github/workflow/status/tschaffter/dnsmasq/ci.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/actions)
[![GitHub License](https://img.shields.io/github/license/tschaffter/dnsmasq.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/blob/develop/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/tschaffter/dnsmasq.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/tschaffter/dnsmasq)

Docker image for Dnsmasq

## Overview

[Dnsmasq] (short for DNS masquerade) is a lightweight, easy to configure DNS
forwarder, designed to provide DNS (and optionally DHCP and TFTP) services to a
small-scale network. It can serve the names of local machines which are not in
the global DNS.

## Features

- Brings the latest release of Dnsmasq to Rapsberry Pi OS and other Debian
  derivatives.
- Enables Dnsmasq to resolve the hostname of an upstream server running in a
  Docker container.
- Provides a Docker image that I can trust until an official image is available
  for Dnsmasq.

## Usage

### Set Upstream DNS Server

There are two ways to specify the address of an upstream DNS server:

- By specifying `server=` in one of Dnsmasq configuration files
  - [dnsmasq.conf](dnsmasq.conf) or
  - [dnsmasq.d/example.com.conf](dnsmasq.d/example.com.conf)
- By specifying the environment variables `SERVER_HOST` and `SERVER_PORT` in
  *docker-compose.yml*.

Both ways can be used to specify a public DNS server like Google Public DNS
(`8.8.8.8`):

- `server=8.8.8.8` or
- `SERVER_HOST=8.8.8.8` and `SERVER_PORT=53`

The second method can be used to specify the service name of a dockerized DNS
server. For example, one could use [Stubby] as a local DNS Privacy stub resolver
that can be used in addition to Dnsmasq to enable DNS-over-TLS.

### Deploying using Docker

Start the Dnsmasq server. Add the option `-d` or `--detach` to run in the
background.

    docker-compose up --build

To stop the server, enter `Ctrl+C` followed by `docker-compose down`. If running
in detached mode, you will only need to enter `docker-compose down`.

## Resolving domain names

[Dig] is a command line utility that performs DNS lookup by querying name
servers and displaying the result to you. After starting dnsmasq, run the
command below to resolve the IP address of github.com.

```console
$ dig @localhost +noall +answer +stats github.com
github.com.             59      IN      A       192.30.255.113
;; Query time: 24 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sun Mar 07 20:55:33 PST 2021
;; MSG SIZE  rcvd: 44
```

The response includes the following information:

- The IP address of github.com is 192.30.255.113.
- The server that returned the result is 127.0.0.1#53 (dnsmasq).
- The query took 24 msec to complete.

Let's run the same command a second time:

```console
$ dig @localhost +noall +answer +stats github.com
github.com.             59      IN      A       192.30.255.113
;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sun Mar 07 20:55:49 PST 2021
;; MSG SIZE  rcvd: 55
```

This time the query time is 0 msec because dnsmasq cached the information after
the first lookup, and all subsequent lookups don't take any time because they
are served from the cache. For more information on how to configure dnsmasq
cache, please read the article [How to Do DNS Caching with dnsmasq].

## Resolving a local domain name

Add the names of your local hosts and their IP addresses to
[hosts.conf](hosts.conf). Then, use `dig` or your browser to check that the
local domain names are properly resolved.

```console
$ dig @localhost +noall +answer +stats host1.example.com
host1.example.com.      0       IN      A       192.168.1.2
;; Query time: 1 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sun Mar 07 21:53:48 PST 2021
;; MSG SIZE  rcvd: 62
```

We can see above that the host name `host1.example.com` has been successfully
resolved to the local IP address `192.168.1.2`.

## License

[Apache License 2.0]

<!-- Links -->

[Dnsmasq]: https://thekelleys.org.uk/gitweb/?p=dnsmasq.git;a=summary
[Stubby]: https://github.com/getdnsapi/stubby
[Dig]: https://en.wikipedia.org/wiki/Dig_(command)

[Stubby server]: https://github.com/tschaffter/stubby
[How to Do DNS Caching with dnsmasq]: https://netbeez.net/blog/linux-dns-caching-dnsmasq/
[Apache License 2.0]: https://github.com/nlpsandbox/date-annotator-example/blob/main/LICENSE