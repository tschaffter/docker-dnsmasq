# Docker image for Dnsmasq

[![GitHub Release](https://img.shields.io/github/release/tschaffter/docker-dnsmasq.svg?include_prereleases&color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/docker-dnsmasq/releases)
[![GitHub CI](https://img.shields.io/github/workflow/status/tschaffter/docker-dnsmasq/CI.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/docker-dnsmasq/actions)
[![GitHub License](https://img.shields.io/github/license/tschaffter/docker-dnsmasq.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/docker-dnsmasq/blob/main/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/tschaffter/dnsmasq.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/tschaffter/dnsmasq)


## Introduction

[Dnsmasq] is a lightweight, easy to configure DNS forwarder, designed to provide
DNS (and optionally DHCP and TFTP) services to a small-scale network. It can
also serve the names of local machines which are not in the global DNS. If you
own an Asus router, it is possible that [your router is using Dnsmasq].

<img alt="Dnsmasq" src="https://raw.githubusercontent.com/tschaffter/docker-dnsmasq/main/images/dnsmasq-icon.svg" height="100px">

This repository:

- enables to run the latest release of Dnsmasq on any hosts that have Docker
  installed.
- automatically checks for new releases of Dnsmasq and promptly publishes a new
  Docker image for Dnsmasq.
- enables Dnsmasq to resolve the hostname of an upstream nameserver running in a
  Docker container (e.g. [tschaffter/docker-getdns-stubby]) using the option
  `--server {docker_service_name}`.


## Contents

- [Specification](#Specification)
- [Requirements](#Requirements)
- [Usage](#Usage)
  - [Quickstart](#Quickstart)
  - [Configuration](#Configuration)
  - [Specifying upstream nameservers](#Specifying-upstream-nameservers)
  - [Connecting Dnsmasq to a dockerized nameserver](Connecting-Dnsmasq-to-a-dockerized-nameserver)
  - [Deploying using Docker](#Deploying-using-Docker)
- [Resolving domain names](#Resolving-domain-names)
- [Resolving a local domain name](#Resolving-a-local-domain-name)
- [Versioning](#Versioning)
  - [GitHub tags](#GitHub-tags)
  - [Docker tags](#Docker-tags)
- [License](#License)


## Specification

- Project version: 1.3.0
- Dnsmasq version: 2.85
- Docker image: [tschaffter/docker-dnsmasq]


## Requirements

- [Docker Engine] >=19.03.0


## Usage

### Quickstart

1. Start Dnsmasq using Docker: `docker compose up -d`
2. Resolve the IP address of `github.com` using [dig] and Dnsmasq:

    ```console
    $ dig @localhost +noall +answer +stats github.com
    github.com.             59      IN      A       192.30.255.113
    ;; Query time: 24 msec
    ;; SERVER: 127.0.0.1#53(127.0.0.1)
    ;; WHEN: Sun Mar 07 20:55:33 PST 2021
    ;; MSG SIZE  rcvd: 44
    ```

3. Stop Dnsmasq: `docker stop dnsmasq`

### Configuration

There are three ways to configure Dnsmasq:

- The main configuration file: [dnsmasq.conf](dnsmasq.conf)
- One or more domain-specific configuration files:
  [dnsmasq.d/example.com.conf](dnsmasq.d/example.com.conf)
- Command-line arguments

This repository provides two example configuration files:

- The file [dnsmasq.conf.example](dnsmasq.conf.example) is the example
  configuration file released by Dnsmasq.
- The file [dnsmasq.conf](dnsmasq.conf) highlights a few options of Dnsmasq.

### Specifying upstream nameservers

Static nameservers like Cloudflare DNS servers (`1.1.1.1` and `1.0.0.1`) or
Google DNS servers (`8.8.8.8` and `8.8.4.4`) can be specified using the
configuration files or command-line arguments (see `docker-compose.yml`).

### Connecting Dnsmasq to a dockerized nameserver

One of the motivations for releasing this Docker image is because Dnsmasq cannot
resolve the address from a nameserver that is not an IP address. This is a
problem when using a nameserver like [Stubby] in a Docker container whose
address is commonly referenced by its Docker service name (Stubby is a local DNS
Privacy stub resolver that can be used in addition to Dnsmasq to enable
DNS-over-TLS).

A solution to this problem is implemented in the entrypoint script
[docker-entrypoint.sh](docker-entrypoint.sh) where the address specified for a
nameserver is resolved to an IP address using the command `ping`. This solution
only applies to server addresses specified as command-line arguments.

### Deploying using Docker

Start the Dnsmasq server. Add the option `-d` or `--detach` to run in the
background.

```console
docker compose up
```

To stop the server, enter `Ctrl+C` followed by `docker compose down`. If running
in detached mode, you will only need to enter `docker compose down`.


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

- The IP address of github.com is 192.30.255.113 (may change over time).
- The response is returned by the server is 127.0.0.1#53 (dnsmasq).
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

### GitHub tags

This repository uses [semantic versioning] to track the releases of this
project. This repository uses "non-moving" GitHub tags, that is, a tag will
always point to the same git commit once it has been created.

### Docker tags

The artifact published by this repository is a Docker image. The versions of the
image are aligned with the versions of Dnsmasq, not the GitHub tags of this
repository. The motivation behind this strategy is that this project is mainly a
wrapper for Dnsmasq and that it is more informative to the user to use a Docker
image tag that correspond to the version of Dnsmasq being deployed.

The table below describes the image tags available.

| Tag name                    | Moving | Description
|-----------------------------|--------|------------
| `latest`                    | Yes    | Latest stable release.
| `edge`                      | Yes    | Latest commit made to the default branch.
| `edge-<sha>`                | No     | Same as above with the reference to the git commit.
| `<major>.<minor>`           | Yes    | Stable release.
| `<major>.<minor>-<sha>`     | No     | Same as above with the reference to the git commit.

> Note: You should avoid using a moving tag like `latest` when deploying
containers in production, because this makes it hard to track which version of
the image is running and hard to roll back. If you prefer to use the latest
version available without manually updating your configuration and
reproducibility is secondary, then it makes sense to use a moving tag.

## License

[Apache License 2.0]

<!-- Links -->

[Dnsmasq]: https://thekelleys.org.uk/gitweb/?p=dnsmasq.git;a=summary
[your router is using Dnsmasq]: https://unfinishedbitness.info/2015/05/26/asuswrt-finalized-setup/
[Stubby]: https://github.com/getdnsapi/stubby
[tschaffter/docker-dnsmasq]: https://hub.docker.com/repository/docker/tschaffter/docker-dnsmasq
[Docker Engine]: https://docs.docker.com/engine/install/
[Dig]: https://en.wikipedia.org/wiki/Dig_(command)
[semantic versioning]: https://semver.org/
[tschaffter/docker-getdns-stubby]: https://github.com/tschaffter/docker-getdns-stubby
[How to Do DNS Caching with dnsmasq]: https://netbeez.net/blog/linux-dns-caching-dnsmasq/
[Apache License 2.0]: https://github.com/tschaffter/docker-dnsmasq/blob/main/LICENSE
