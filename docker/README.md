# Docker Images for CentOS Stream

This directory contains Docker configurations for multiple CentOS Stream versions.

## Supported Versions

| Version | CentOS Stream | Base Image                     | Tag Format                    |
| ------- | ------------- | ------------------------------ | ----------------------------- |
| 9       | Stream 9      | quay.io/centos/centos:stream9  | 9-v9.0.0, 9-latest            |
| 10      | Stream 10     | quay.io/centos/centos:stream10 | 10-v10.0.0, 10-latest, latest |

## Directory Structure

```
docker/
├── 9/                           # CentOS Stream 9
│   ├── Dockerfile               # Multi-stage Dockerfile
│   ├── docker-entrypoint.sh     # Container entrypoint script
│   ├── vimrc.local              # Vim configuration
│   └── entrypoint.d/            # Entrypoint scripts directory
│       ├── 00-base-init.sh      # Initialization script
│       └── 01-base-setup.sh     # Setup script (user, umask)
└── 10/                          # CentOS Stream 10
    ├── Dockerfile               # Multi-stage Dockerfile
    ├── docker-entrypoint.sh     # Container entrypoint script
    ├── vimrc.local              # Vim configuration
    └── entrypoint.d/            # Entrypoint scripts directory
        ├── 00-base-init.sh      # Initialization script
        └── 01-base-setup.sh     # Setup script (user, umask)
```

## Features

- **Multi-architecture support**: amd64, arm64, ppc64le, s390x
- **Enterprise base**: Official CentOS Stream base image
- **User management**: Support for custom PUID/PGID
- **Configurable**: Environment variables for customization
- **Entrypoint scripts**: Modular initialization system

## Environment Variables

| Variable               | Default | Description                          |
| ---------------------- | ------- | ------------------------------------ |
| `KEEPALIVE`            | 0       | Keep container running (1=yes, 0=no) |
| `CAP_NET_BIND_SERVICE` | 0       | Enable binding to privileged ports   |
| `LANG`                 | C.UTF-8 | Locale setting                       |
| `UMASK`                | 022     | File creation mask                   |
| `DEBUG`                | false   | Enable debug output                  |
| `PASSWORDLESS_SUDO`    | false   | Grant passwordless sudo to user      |
| `PGID`                 | 0       | Group ID for custom user             |
| `PUID`                 | 0       | User ID for custom user              |
| `USER`                 | root    | Username                             |
| `WORKDIR`              | /root   | Working directory                    |

## Usage

### Pull from Docker Hub

```bash
# CentOS Stream 10 (latest)
docker pull snowdreamtech/centos:latest
docker pull snowdreamtech/centos:10-latest
docker pull snowdreamtech/centos:10-v10.0.0

# CentOS Stream 9
docker pull snowdreamtech/centos:9-latest
docker pull snowdreamtech/centos:9-v9.0.0
```

### Pull from GitHub Container Registry

```bash
# CentOS Stream 10 (latest)
docker pull ghcr.io/snowdreamtech/centos:latest
docker pull ghcr.io/snowdreamtech/centos:10-latest
docker pull ghcr.io/snowdreamtech/centos:10-v10.0.0

# CentOS Stream 9
docker pull ghcr.io/snowdreamtech/centos:9-latest
docker pull ghcr.io/snowdreamtech/centos:9-v9.0.0
```

### Run Container

```bash
# Basic usage
docker run -it snowdreamtech/centos:latest

# With custom user
docker run -it -e PUID=1000 -e PGID=1000 -e USER=myuser snowdreamtech/centos:latest

# Keep container running
docker run -d -e KEEPALIVE=1 snowdreamtech/centos:latest

# With debug output
docker run -it -e DEBUG=true snowdreamtech/centos:latest
```

## Building Locally

```bash
# Build CentOS Stream 9
docker build -t centos:9-local docker/9/

# Build CentOS Stream 10
docker build -t centos:10-local docker/10/

# Build with specific platform
docker buildx build --platform linux/amd64,linux/arm64 -t centos:10-local docker/10/
```

## Installed Packages

Each image includes the following packages:

- **System utilities**: lsb-release, procps-ng, sudo, vim-enhanced
- **Compression tools**: zip, unzip, bzip2, xz, gzip
- **File utilities**: file
- **JSON processor**: jq
- **Time zone data**: tzdata
- **Security**: openssl, gnupg2, ca-certificates
- **System monitoring**: sysstat
- **Network tools**: wget, curl, git, bind-utils, nmap-ncat, traceroute, iputils, net-tools, lsof
- **Container utilities**: libcap, gosu

## Entrypoint System

The entrypoint system executes scripts in `/usr/local/bin/entrypoint.d/` in alphabetical order:

1. **00-base-init.sh**: Initialization placeholder
2. **01-base-setup.sh**: User creation, umask configuration

## License

MIT License - see [LICENSE](../LICENSE) for details.

## Maintainer

Snowdream Tech - <https://github.com/snowdreamtech>
