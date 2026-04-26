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

CentOS Stream 的 Docker 镜像。支持多平台架构：(amd64, arm64, ppc64le, s390x)

## 支持的版本

| 版本 | CentOS Stream | 基础镜像 | 标签格式 | 状态 |
|------|---------------|----------|----------|------|
| 9 | Stream 9 | quay.io/centos/centos:stream9 | `9-v9.0.0` | ✅ 活跃 |
| 10 | Stream 10 | quay.io/centos/centos:stream10 | `10-v10.0.0` | ✅ 活跃 |

## 支持的架构

- `linux/amd64` - x86_64 架构
- `linux/arm64` - ARM 64位架构
- `linux/ppc64le` - PowerPC 64位小端序
- `linux/s390x` - IBM System z 架构（版本 9 和 10）


## 快速开始

### Docker 命令行

#### 基础用法

```bash
docker run -d \
  --name=centos \
  -e TZ=Asia/Shanghai \
  snowdreamtech/centos:10-v10.0.0
```

#### 高级用法（用户映射）

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

## 环境变量

| 变量 | 默认值 | 描述 |
|------|--------|------|
| `PUID` | `0` | 文件权限的用户ID |
| `PGID` | `0` | 文件权限的组ID |
| `USER` | `root` | 要创建/使用的用户名 |
| `PASSWORDLESS_SUDO` | `false` | 为用户启用无密码sudo |
| `KEEPALIVE` | `0` | 保持容器运行（1=启用） |
| `DEBUG` | `false` | 启用调试日志 |
| `UMASK` | `022` | 默认文件创建掩码 |
| `WORKDIR` | `/root` | 工作目录 |
| `TZ` | - | 时区（例如：Asia/Shanghai） |
| `CAP_NET_BIND_SERVICE` | `0` | 允许绑定到特权端口 |

## 功能特性

### 安全性
- **gosu 集成**：通过 GPG 验证实现安全的权限降级
- **用户映射**：灵活的 PUID/PGID 映射用于文件权限管理
- **最小基础**：使用 CentOS Stream 最小镜像减少攻击面
- **安全扫描**：使用 Trivy 进行自动化漏洞扫描

### 架构
- **多架构支持**：原生支持 amd64、arm64、ppc64le、s390x（取决于版本）
- **模块化入口点**：Alpine 风格的初始化系统，使用 entrypoint.d/
- **调试支持**：通过 DEBUG 环境变量提供全面的日志记录
- **信号处理**：正确的信号转发以实现优雅关闭

### 包管理
- **仓库配置**：正确的 dnf 仓库设置（CRB、devel、extras、EPEL）
- **基础工具**：预安装的开发和运维工具
- **版本特定**：针对每个 CentOS Stream 版本优化的包选择
- **清洁安装**：全面的清理和缓存管理

## 构建说明

### 前提条件

- 支持 Buildx 的 Docker
- 多架构模拟（QEMU）

### 本地构建

```bash
# 单架构构建
docker build -t centos:local ./docker/10

# 多架构构建（版本 10）
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/centos:10-v10.0.0 \
  ./docker/10 \
  --push

# 版本 8 构建（不包含 s390x）
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/ppc64le \
  -t snowdreamtech/centos:8-v8.0.0 \
  ./docker/8 \
  --push
```

### 构建参数

| 参数 | 默认值 | 描述 |
|------|--------|------|
| `BUILDTIME` | - | 构建时间戳 |
| `VERSION` | - | 镜像版本 |
| `REVISION` | - | Git 修订版本 |
| `KEEPALIVE` | `0` | 默认保活设置 |
| `DEBUG` | `false` | 默认调试设置 |
| `LANG` | `C.UTF-8` | 默认语言环境 |

## 开发

### 项目结构

```
centos/
├── docker/                    # Docker 配置
│   ├── 8/                    # CentOS Stream 8
│   │   ├── Dockerfile        # 版本特定的 Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   ├── entrypoint.d/     # 初始化脚本
│   │   └── vimrc.local       # Vim 配置
│   ├── 9/                    # CentOS Stream 9
│   └── 10/                   # CentOS Stream 10
├── .github/workflows/         # CI/CD 工作流
└── docs/                     # 文档
```

### 贡献

1. Fork 仓库
2. 创建功能分支
3. 进行更改
4. 在所有支持的版本上测试
5. 提交拉取请求

### 测试

```bash
# 运行基本功能测试
docker run --rm snowdreamtech/centos:10-v10.0.0 \
  /bin/bash -c "echo '测试通过'"

# 测试用户映射
docker run --rm -e PUID=1000 -e PGID=1000 -e USER=testuser \
  snowdreamtech/centos:10-v10.0.0 /bin/bash -c "id"

# 测试调试模式
docker run --rm -e DEBUG=true \
  snowdreamtech/centos:10-v10.0.0 /bin/bash -c "echo '调试测试'"
```

## 故障排除

### 常见问题

#### 权限被拒绝错误
```bash
# 确保正确的 PUID/PGID 映射
docker run -e PUID=$(id -u) -e PGID=$(id -g) snowdreamtech/centos:10-v10.0.0
```

#### 容器立即退出
```bash
# 启用保活模式
docker run -e KEEPALIVE=1 snowdreamtech/centos:10-v10.0.0
```

#### 调试信息
```bash
# 启用调试日志
docker run -e DEBUG=true snowdreamtech/centos:10-v10.0.0
```

### 获取帮助

- **问题反馈**：[GitHub Issues](https://github.com/snowdreamtech/centos/issues)
- **讨论**：[GitHub Discussions](https://github.com/snowdreamtech/centos/discussions)
- **文档**：[项目 Wiki](https://github.com/snowdreamtech/centos/wiki)

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

## 致谢

- [CentOS 项目](https://www.centos.org/) 提供优秀的 Linux 发行版
- [Alpine Linux](https://alpinelinux.org/) 在容器设计模式方面的启发
- [gosu](https://github.com/tianon/gosu) 提供安全的权限降级

## 相关项目

- [Rocky Linux Docker 镜像](https://github.com/snowdreamtech/rocky)
- [Alpine Docker 镜像](https://github.com/snowdreamtech/alpine)
- [Ubuntu Docker 镜像](https://github.com/snowdreamtech/ubuntu)
- [Debian Docker 镜像](https://github.com/snowdreamtech/debian)
