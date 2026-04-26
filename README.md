# CentOS

[![GitHub Release](https://img.shields.io/github/v/release/snowdreamtech/centos?include_prereleases&sort=semver)](https://github.com/snowdreamtech/centos/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![CodeSize](https://img.shields.io/github/languages/code-size/snowdreamtech/centos)](https://github.com/snowdreamtech/centos)
[![Dependabot Enabled](https://img.shields.io/badge/Dependabot-Enabled-brightgreen?logo=dependabot)](https://github.com/snowdreamtech/centos/blob/main/.github/dependabot.yml)
![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/centos)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/centos/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/centos)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/centos)

[English](README.md) | [简体中文](README_zh-CN.md)

Docker Image packaging for CentOS Stream. (amd64, arm64, ppc64le, s390x)

## Supported Versions

| Version | CentOS Stream | Base Image | Tag Format | Status |
|---------|---------------|------------|------------|--------|
| 9 | Stream 9 | quay.io/centos/centos:stream9 | `9-v9.0.0` | ✅ Active |
| 10 | Stream 10 | quay.io/centos/centos:stream10 | `10-v10.0.0` | ✅ Active |

## Supported Architectures

- `linux/amd64` - x86_64 architecture
- `linux/arm64` - ARM 64-bit architecture
- `linux/ppc64le` - PowerPC 64-bit Little Endian
- `linux/s390x` - IBM System z architecture (versions 9 and 10)

## Quick Start

### Docker CLI

#### Basic Usage

```bash
docker run -d \
  --name=centos \
  -e TZ=Asia/Shanghai \
  snowdreamtech/centos:10-v10.0.0
```

#### Advanced Usage with User Mapping

```bash
docker run -d \
  --name=centos \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=myuser \
  -e PASSWORDLESS_SUDO=true \
  -e DEBUG=true \
  -e TZ=Asia/Shanghai \
  -v /path/to/data:/data \
  snowdreamtech/centos:10-v10.0.0
```

### Docker Compose

```yaml
version: '3.8'

services:
  centos:
    image: snowdreamtech/centos:10-v10.0.0
    container_name: centos
    environment:
      - PUID=1000
      - PGID=1000
      - USER=myuser
      - PASSWORDLESS_SUDO=true
      - DEBUG=false
      - TZ=Asia/Shanghai
      - KEEPALIVE=1
    volumes:
      - ./data:/data
    restart: unless-stopped
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `0` | User ID for file permissions |
| `PGID` | `0` | Group ID for file permissions |
| `USER` | `root` | Username to create/use |
| `PASSWORDLESS_SUDO` | `false` | Enable passwordless sudo for user |
| `KEEPALIVE` | `0` | Keep container running (1=enabled) |
| `DEBUG` | `false` | Enable debug logging |
| `UMASK` | `022` | Default file creation mask |
| `WORKDIR` | `/root` | Working directory |
| `TZ` | - | Timezone (e.g., Asia/Shanghai) |
| `CAP_NET_BIND_SERVICE` | `0` | Allow binding to privileged ports |

## Features

### Security

- **gosu Integration**: Secure privilege dropping with GPG verification
- **User Mapping**: Flexible PUID/PGID mapping for file permissions
- **Minimal Base**: Uses CentOS Stream minimal images for reduced attack surface
- **Security Scanning**: Automated vulnerability scanning with Trivy

### Architecture

- **Multi-Architecture**: Native support for amd64, arm64, ppc64le, s390x (version-dependent)
- **Modular Entrypoint**: Alpine-style initialization system with entrypoint.d/
- **Debug Support**: Comprehensive logging with DEBUG environment variable
- **Signal Handling**: Proper signal forwarding for graceful shutdown

### Package Management

- **Repository Configuration**: Proper dnf repository setup (CRB, devel, extras, EPEL)
- **Essential Tools**: Pre-installed development and operational tools
- **Version Specific**: Optimized package selection for each CentOS Stream version
- **Clean Installation**: Comprehensive cleanup and cache management

## Build Instructions

### Prerequisites

- Docker with Buildx support
- Multi-architecture emulation (QEMU)

### Building Locally

```bash
# Build for single architecture
docker build -t centos:local ./docker/10

# Build for multiple architectures (version 10)
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/centos:10-v10.0.0 \
  ./docker/10 \
  --push

# Build for version 8 (without s390x)
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/ppc64le \
  -t snowdreamtech/centos:8-v8.0.0 \
  ./docker/8 \
  --push
```

### Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `BUILDTIME` | - | Build timestamp |
| `VERSION` | - | Image version |
| `REVISION` | - | Git revision |
| `KEEPALIVE` | `0` | Default keepalive setting |
| `DEBUG` | `false` | Default debug setting |
| `LANG` | `C.UTF-8` | Default locale |

## Development

### Project Structure

```
centos/
├── docker/                    # Docker configurations
│   ├── 8/                    # CentOS Stream 8
│   │   ├── Dockerfile        # Version-specific Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   ├── entrypoint.d/     # Initialization scripts
│   │   └── vimrc.local       # Vim configuration
│   ├── 9/                    # CentOS Stream 9
│   └── 10/                   # CentOS Stream 10
├── .github/workflows/         # CI/CD workflows
└── docs/                     # Documentation
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test across all supported versions
5. Submit a pull request

### Testing

```bash
# Run basic functionality test
docker run --rm snowdreamtech/centos:10-v10.0.0 \
  /bin/bash -c "echo 'Test passed'"

# Test user mapping
docker run --rm -e PUID=1000 -e PGID=1000 -e USER=testuser \
  snowdreamtech/centos:10-v10.0.0 /bin/bash -c "id"

# Test debug mode
docker run --rm -e DEBUG=true \
  snowdreamtech/centos:10-v10.0.0 /bin/bash -c "echo 'Debug test'"
```

## Troubleshooting

### Common Issues

#### Permission Denied Errors

```bash
# Ensure proper PUID/PGID mapping
docker run -e PUID=$(id -u) -e PGID=$(id -g) snowdreamtech/centos:10-v10.0.0
```

#### Container Exits Immediately

```bash
# Enable keepalive mode
docker run -e KEEPALIVE=1 snowdreamtech/centos:10-v10.0.0
```

#### Debug Information

```bash
# Enable debug logging
docker run -e DEBUG=true snowdreamtech/centos:10-v10.0.0
```

### Getting Help

- **Issues**: [GitHub Issues](https://github.com/snowdreamtech/centos/issues)
- **Discussions**: [GitHub Discussions](https://github.com/snowdreamtech/centos/discussions)
- **Documentation**: [Project Wiki](https://github.com/snowdreamtech/centos/wiki)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [CentOS Project](https://www.centos.org/) for the excellent Linux distribution
- [Alpine Linux](https://alpinelinux.org/) for inspiration on container design patterns
- [gosu](https://github.com/tianon/gosu) for secure privilege dropping

## Related Projects

- [Rocky Linux Docker Images](https://github.com/snowdreamtech/rocky)
- [Alpine Docker Images](https://github.com/snowdreamtech/alpine)
- [Ubuntu Docker Images](https://github.com/snowdreamtech/ubuntu)
- [Debian Docker Images](https://github.com/snowdreamtech/debian)
