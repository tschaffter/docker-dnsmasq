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

- Brings the latest release of [Dnsmasq] to Rapsberry Pi OS and other Debian
  derivatives.
- Enables [Dnsmasq] to resolve the hostname of an upstream server running in a
  Docker container.
- Provides a Docker image that I can trust until an official image is available
  for [Dnsmasq].

## Usage



## License

[Apache License 2.0]

<!-- Links -->

[Dnsmasq]: https://thekelleys.org.uk/gitweb/?p=dnsmasq.git;a=summary
[Stubby server]: https://github.com/tschaffter/stubby
[Apache License 2.0]: https://github.com/nlpsandbox/date-annotator-example/blob/main/LICENSE