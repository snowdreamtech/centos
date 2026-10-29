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

CentOS Stream 的 Docker 基础镜像。支持多平台架构：(amd64, arm64, ppc64le, s390x)

## 支持的版本

| 版本 | CentOS Stream | 基础镜像                       | Docker 标签                         | 状态      |
| :--- | :------------ | :----------------------------- | :---------------------------------- | :-------- |
| 10   | Stream 10     | quay.io/centos/centos:stream10 | `latest`, `10-latest`, `10-v10.0.0` | ✅ Active |
| 9    | Stream 9      | quay.io/centos/centos:stream9  | `9-latest`, `9-v9.0.0`              | ✅ Active |

## 使用方法

你可以使用 docker compose 或 docker cli 启动容器。

### Docker Cli

#### 简单模式 (CLI)

```bash
docker run -d \
  --name=centos \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/centos:latest
```

#### 进阶模式 (CLI)

```bash
docker run -d \
  --name=centos \
  -e TZ=Asia/Shanghai \
  -v /path/to/data:/path/to/data \
  --restart unless-stopped \
  snowdreamtech/centos:latest
```

### Docker Compose

#### 简单模式 (Compose)

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

#### 进阶模式 (Compose)

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

## 环境变量

该镜像提供多个环境变量以自定义其运行时行为。

| 环境变量               | 默认值    | 描述                                                       |
| :--------------------- | :-------- | :--------------------------------------------------------- |
| `PUID`                 | `0`       | 运行进程的用户 ID。                                        |
| `PGID`                 | `0`       | 运行进程的用户组 ID。                                      |
| `USER`                 | `root`    | 运行进程的用户名。                                         |
| `PASSWORDLESS_SUDO`    | `false`   | 设置为 `true` 以向映射用户授予免密 `sudo` 提权权限。       |
| `WORKDIR`              | `/root`   | 默认工作目录。                                             |
| `UMASK`                | `022`     | 文件创建权限掩码。                                         |
| `DEBUG`                | `false`   | 启用 entrypoint 脚本的详细调试日志。                       |
| `KEEPALIVE`            | `0`       | 设置为 `1` 以使容器在后台持续运行。                        |
| `TZ`                   | `UTC`     | 系统时区设置。                                             |
| `CAP_NET_BIND_SERVICE` | `0`       | 设置为 `1` 以允许非 root 绑定特权端口（< 1024）。          |
| `LANG`                 | `C.UTF-8` | 系统语言和字符集。                                         |

## 特性

### 用户映射与权限控制

你可以使用 `PUID` 和 `PGID` 将容器内运行的用户映射为您宿主机的用户 ID 和组 ID。这在挂载外部数据卷时能够完美避免权限问题。

```bash
docker run -d \
  -e PUID=1000 \
  -e PGID=1000 \
  snowdreamtech/centos:latest
```

默认情况下，映射用户**不具备** `sudo` 权限。如需在开发或调试时启用免密特权提升，请设置 `PASSWORDLESS_SUDO=true`：

```bash
docker run -d \
  -e PUID=1000 \
  -e PGID=1000 \
  -e PASSWORDLESS_SUDO=true \
  snowdreamtech/centos:latest
```

> **安全提示**：请勿在生产环境中启用 `PASSWORDLESS_SUDO=true`，这会导致容器内进程无需密码即可提权至 root。

### 入口点脚本扩展 (`entrypoint.d`)

镜像支持自定义初始化脚本扩展机制。放置在 `/usr/local/bin/entrypoint.d/` 中的任何可执行脚本都会在容器启动时按字母顺序自动执行。

### 预装核心工具

镜像内置了开箱即用的运维与网络诊断工具链：

- **Shell**: `bash`, `zsh`
- **编辑器**: `vim-enhanced`, `nano`
- **网络工具**: `curl`, `wget`, `rsync`, `git`, `bind-utils`, `iputils`, `net-tools`, `nmap-ncat`, `traceroute`, `lsof`
- **系统与实用工具**: `sudo`, `gosu`, `procps-ng`, `jq`, `ca-certificates`, `tzdata`, `libcap`

## 开发指南

### 前置要求

- Docker (>= 20.10) 且支持 Docker Buildx 插件
- [UniRTM](https://github.com/snowdreamtech/UniRTM) 用于工作区质量守卫与工具链管理

### 代码质量与验证

```bash
# 安装并配置工具链
unirtm run setup

# 运行完整工作区质量检查（格式化、静态检查、安全性）
unirtm run verify

# 运行安全审计（Zizmor, Gitleaks, OSV-Scanner, Trivy）
unirtm run audit

# 自动修复支持的代码规范与格式问题
unirtm run fix
```

### 本地构建

```bash
# 构建指定的 CentOS Stream 镜像变体
docker build -t centos:10 ./docker/10/
docker build -t centos:9 ./docker/9/
```

## 参考资料

1. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
2. [如何使用 docker buildx 构建跨平台 Go 镜像](https://waynerv.com/posts/building-multi-architecture-images-with-docker-buildx/#buildx-%E7%9A%84%E8%B7%A8%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E7%AD%96%E7%95%A5)
3. [Building Multi-Arch Images for Arm and x86 with Docker Desktop](https://www.docker.com/blog/multi-arch-images/)
4. [How to Rapidly Build Multi-Architecture Images with Buildx](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/)
5. [Faster Multi-Platform Builds: Dockerfile Cross-Compilation Guide](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)
6. [docker/buildx](https://github.com/docker/buildx)

---

Copyright (c) 2024-present [SnowdreamTech Inc.](https://github.com/snowdreamtech)
