# CentOS

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/centos/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/centos/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/centos/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/centos/actions/workflows/cd.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/snowdreamtech/centos/codeql.yml?branch=main&label=CodeQL&logo=github)](https://github.com/snowdreamtech/centos/actions/workflows/codeql.yml)
[![Security Audit](https://img.shields.io/badge/Security-Zizmor%20%7C%20Trivy%20%7C%20Gitleaks-brightgreen)](https://github.com/snowdreamtech/centos/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/centos)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/centos/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/centos)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/centos)

[English](README.md) | [简体中文](README_zh-CN.md)

Docker Image packaging for CentOS Stream. (amd64, arm64, ppc64le, s390x)

## Supported Versions

| Version | CentOS Stream | Base Image                     | Docker Tags                         | Status    |
| :------ | :------------ | :----------------------------- | :---------------------------------- | :-------- |
| 10      | Stream 10     | quay.io/centos/centos:stream10 | `latest`, `10-latest`, `10-v10.0.0` | ✅ Active |
| 9       | Stream 9      | quay.io/centos/centos:stream9  | `9-latest`, `9-v9.0.0`              | ✅ Active |

## Usage

To help you get started creating a container from this image you can either use docker compose or the docker cli.

### Docker Cli

#### CLI - Simple

```bash
docker run -d \
  --name=centos \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/centos:latest
```

#### CLI - Advance

```bash
docker run -d \
  --name=centos \
  -e TZ=Asia/Shanghai \
  -v /path/to/data:/path/to/data \
  --restart unless-stopped \
  snowdreamtech/centos:latest
```

### Docker Compose

#### Compose - Simple

```yaml
version: "3"

services:
  centos:
    image: snowdreamtech/centos:latest
    container_name: centos
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
```

#### Compose - Advance

```yaml
version: "3"

services:
  centos:
    image: snowdreamtech/centos:latest
    container_name: centos
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /path/to/data:/path/to/data
    restart: unless-stopped
```

## Environment Variables

This image provides several environment variables to customize its behavior.

| Variable               | Default   | Description                                                          |
| :--------------------- | :-------- | :------------------------------------------------------------------- |
| `PUID`                 | `0`       | User ID for the running process.                                     |
| `PGID`                 | `0`       | Group ID for the running process.                                    |
| `USER`                 | `root`    | Username for the running process.                                    |
| `PASSWORDLESS_SUDO`    | `false`   | Set to `true` to grant the mapped user passwordless `sudo`.          |
| `WORKDIR`              | `/root`   | Working directory.                                                   |
| `UMASK`                | `022`     | Umask for file creation.                                             |
| `DEBUG`                | `false`   | Enable debug logging for the entrypoint.                             |
| `KEEPALIVE`            | `0`       | Set to `1` to keep the container running indefinitely.               |
| `TZ`                   | `UTC`     | Timezone setting.                                                    |
| `CAP_NET_BIND_SERVICE` | `0`       | Set to `1` to grant permission to bind to privileged ports (< 1024). |
| `LANG`                 | `C.UTF-8` | System locale and language setting.                                  |

## Features

### User Mapping & Permissions

You can map the internal user to your host user's ID and Group ID using `PUID` and `PGID`. This is extremely useful for avoiding permission issues when using volumes.

```bash
docker run -d \
  -e PUID=1000 \
  -e PGID=1000 \
  snowdreamtech/centos:latest
```

By default, the mapped user does **not** have `sudo` access. To enable passwordless privilege escalation (e.g., for development or debugging), set `PASSWORDLESS_SUDO=true`:

```bash
docker run -d \
  -e PUID=1000 \
  -e PGID=1000 \
  -e PASSWORDLESS_SUDO=true \
  snowdreamtech/centos:latest
```

> **Security note**: Do not set `PASSWORDLESS_SUDO=true` in production environments, as it allows the container process to escalate to root without a password.

### Entrypoint Extension (`entrypoint.d`)

This image supports an extension mechanism for custom initialization scripts. Any executable script placed in `/usr/local/bin/entrypoint.d/` (or the project's `entrypoint.d/` folder before build) will be executed in alphabetical order during container startup.

### Included Packages

The image comes pre-installed with a curated set of essential tools:

- **Shell**: `bash`, `zsh`
- **Editors**: `vim-enhanced`, `nano`
- **Network**: `curl`, `wget`, `rsync`, `git`, `bind-utils`, `iputils`, `net-tools`, `nmap-ncat`, `traceroute`, `lsof`
- **Utils**: `sudo`, `gosu`, `procps-ng`, `jq`, `ca-certificates`, `tzdata`, `libcap`

## Development

### Prerequisites

- Docker (>= 20.10) with Docker Buildx plugin
- [UniRTM](https://github.com/snowdreamtech/UniRTM) for workspace quality guard and toolchain management

### Quality & Verification

```bash
# Setup toolchain and verify environment
unirtm run setup

# Run comprehensive workspace quality check (formatters, linters, security)
unirtm run verify

# Run security audits (Zizmor, Gitleaks, OSV-Scanner, Trivy)
unirtm run audit

# Automatically fix linting and formatting issues where supported
unirtm run fix
```

### Building Locally

```bash
# Build specific CentOS Stream variant
docker build -t centos:10 ./docker/10/
docker build -t centos:9 ./docker/9/
```

## Reference

1. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
2. [如何使用 docker buildx 构建跨平台 Go 镜像](https://waynerv.com/posts/building-multi-architecture-images-with-docker-buildx/#buildx-%E7%9A%84%E8%B7%A8%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E7%AD%96%E7%95%A5)
3. [Building Multi-Arch Images for Arm and x86 with Docker Desktop](https://www.docker.com/blog/multi-arch-images/)
4. [How to Rapidly Build Multi-Architecture Images with Buildx](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/)
5. [Faster Multi-Platform Builds: Dockerfile Cross-Compilation Guide](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)
6. [docker/buildx](https://github.com/docker/buildx)

---

Copyright (c) 2024-present [SnowdreamTech Inc.](https://github.com/snowdreamtech)
