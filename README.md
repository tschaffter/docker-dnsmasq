# Dnsmasq

[![GitHub Release](https://img.shields.io/github/release/tschaffter/dnsmasq.svg?include_prereleases&color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/releases)
[![GitHub CI](https://img.shields.io/github/workflow/status/tschaffter/dnsmasq/ci.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/actions)
[![GitHub License](https://img.shields.io/github/license/tschaffter/dnsmasq.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/blob/develop/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/tschaffter/dnsmasq.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/tschaffter/dnsmasq)

Small caching DNS proxy and DHCP/TFTP server

## Introduction

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

Both ways can be used to specify a public DNS server like Google Public DNS:

- `server=8.8.8.8` or
- `SERVER_HOST=8.8.8.8` and `SERVER_PORT=53`

The second method can be used to specify the service name of a dockerized DNS
server. An example of such server could be Stubby, a local DNS Privacy stub
resolver that can be used in addition to Dnsmasq to enable DNS-over-TLS.

### Start Dnsmasq

This command starts Dnsmasq:

    docker-compose up -d

This command stops Dnsmasq:

    docker-compose down

### Resolve a Domain Name

Dig (Domain Information Groper) is a command line utility that performs DNS
lookup by querying name servers and displaying the result to you.

Start by installing `dig`:

- Debian and Ubuntu: `apt-get install dnsutils`
- CentOS: `yum install bind-utils`

After starting dnsmasq, run the command below to resolve the IP address of
github.com.

```
$ dig @localhost +noall +answer +stats github.com
github.com.             59      IN      A       192.30.255.113
;; Query time: 24 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sun Mar 07 20:55:33 PST 2021
;; MSG SIZE  rcvd: 44
```

The result returned includes the following information:

- The IP address of github.com is 192.30.255.113.
- The server that returned the result is 127.0.0.1#53 (dnsmasq).
- The query took 24 msec to complete.

Let's run the same command a second time:

```
$ dig @localhost +noall +answer +stats github.com
github.com.             59      IN      A       192.30.255.113
;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sun Mar 07 20:55:49 PST 2021
;; MSG SIZE  rcvd: 55
```

This time the query time is 0 msec. That's because dnsmasq cached the
information after the first lookup, and all subsequent lookups don't take any
time because they are served from the cache. For more information on how to
configure dnsmasq cache, please read the article [How to Do DNS Caching with
dnsmasq].

### DNS Reverse Look-up

Dnsmasq can also be used to perform DNS reverse look-up.

```
$ dig @localhost -x 192.30.255.113 +short
lb-192-30-255-113-sea.github.com.
```

## License

[Apache License 2.0]

<!-- Links -->

[Dnsmasq]: https://thekelleys.org.uk/gitweb/?p=dnsmasq.git;a=summary
[Stubby server]: https://github.com/tschaffter/stubby
[How to Do DNS Caching with dnsmasq]: https://netbeez.net/blog/linux-dns-caching-dnsmasq/
[Apache License 2.0]: https://github.com/nlpsandbox/date-annotator-example/blob/main/LICENSE