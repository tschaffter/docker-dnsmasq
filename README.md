# Dnsmasq

[![GitHub Release](https://img.shields.io/github/release/tschaffter/dnsmasq.svg?include_prereleases&color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/releases)
[![GitHub CI](https://img.shields.io/github/workflow/status/tschaffter/dnsmasq/CI.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/actions)
[![GitHub License](https://img.shields.io/github/license/tschaffter/dnsmasq.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/dnsmasq/blob/develop/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/tschaffter/dnsmasq.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/tschaffter/dnsmasq)

Docker image for Dnsmasq

## Overview

[Dnsmasq] is a lightweight, easy to configure DNS forwarder, designed to provide
DNS (and optionally DHCP and TFTP) services to a small-scale network. It can
also serve the names of local machines which are not in the global DNS.If you
own an Asus router, there is a chance that [your Asus router is using Dnsmasq].

## Features

- Brings the latest release of Dnsmasq to any host that has Docker installed. A
  Pull Request that updates this GitHub repository is automatically created when
  a new version of Dnsmasq is available (see
  [update.yml](.github/workflows/update.yml)).
- Enables Dnsmasq to resolve the hostname of an upstream nameserver running in a
  Docker container (e.g. Stubby).
- Provides a Docker image that I can trust until an official image is available
  for Dnsmasq.

## Usage

### Configuration

There are three sources of configuration that you can use:

- Main configuration: [dnsmasq.conf](dnsmasq.conf)
- Domain-specific configuration(s): [dnsmasq.d/example.com.conf](dnsmasq.d/example.com.conf)
- Command-line arguments

The file [dnsmasq.conf.example](dnsmasq.conf.example) is the default main
configuration file provided with the latest release of Dnsmasq available in this
GitHub repository. The file [dnsmasq.conf](dnsmasq.conf) highlights some options
of Dnsmasq.

### Set upstream nameservers

Static nameservers like Cloudflare DNS servers `1.1.1.1` and `1.0.0.1` or Google
DNS servers `8.8.8.8` and `8.8.4.4` can be specified using any sources of
configuration.

One of the reason for building this Docker image is because Dnsmasq cannot
resolve the address from a nameserver that is not an IP address. This is a
problem when using a nameserver like [Stubby] in a Docker container whose
address is commonly referenced by its Docker service name. Stubby is a local DNS
Privacy stub resolver that can be used in addition to Dnsmasq to enable
DNS-over-TLS.

A solution to the problem mentioned above is implemented in the entrypoint
script [docker-entrypoint.sh](docker-entrypoint.sh) where the address specified
for a nameserver is resolved to an IP address using the command `ping`. Thus,
this solution only applies to server addresses specified as command-line
arguments.

### Deploying using Docker

Start the Dnsmasq server. Add the option `-d` or `--detach` to run in the
background.

    docker-compose up --build

To stop the server, enter `Ctrl+C` followed by `docker-compose down`. If running
in detached mode, you will only need to enter `docker-compose down`.

## Resolving domain names

[Dig] is a command line utility that performs DNS lookup by querying name
servers and displaying the result to you. After starting Dnsmasq, run the
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

This time the query time is 0 msec because Dnsmasq cached the information after
the first lookup, and all subsequent lookups don't take any time because they
are served from the cache. For more information on how to configure Dnsmasq
cache, please read the article [How to Do DNS Caching with dnsmasq].

## Resolving a local domain name

See example specified in
[dnsmasq.d/example.com.conf](dnsmasq.d/example.com.conf).

```console
$ dig @localhost +noall +answer +stats myhost.example.com
myhost.example.com.      0       IN      A       192.168.1.10
;; Query time: 1 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Sun Mar 07 21:53:48 PST 2021
;; MSG SIZE  rcvd: 62
```

We can see above that the host name `myhost.example.com` has been successfully
resolved to the local IP address `192.168.1.10`.

## Versioning

It is recommended to use a tag other than `latest` if you are using this image
in a production setting. The tags of this image match the versions of Dnsmasq
installed.

## License

[Apache License 2.0]

<!-- Links -->

[Dnsmasq]: https://thekelleys.org.uk/gitweb/?p=dnsmasq.git;a=summary
[your Asus router is using Dnsmasq]: https://unfinishedbitness.info/2015/05/26/asuswrt-finalized-setup/
[Stubby]: https://github.com/getdnsapi/stubby
[Dig]: https://en.wikipedia.org/wiki/Dig_(command)

[Stubby server]: https://github.com/tschaffter/stubby
[How to Do DNS Caching with dnsmasq]: https://netbeez.net/blog/linux-dns-caching-dnsmasq/
[Apache License 2.0]: https://github.com/tschaffter/dnsmasq/blob/main/LICENSE
