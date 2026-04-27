# CentOS Stream Base Image

# Technical Purpose: High-performance, multi-architecture base image for Snowdream Tech projects.
# Design:
#   - Optimized layering for minimal image size.
#   - Decoupled initialization via entrypoint.d mechanism.
#   - Native support for PUID/PGID user mapping.
#   - Pre-installed with essential dev/ops tooling (Git, Curl, Sudo, etc.).

# Base image difference: CentOS Stream uses quay.io registry instead of Docker Hub
FROM quay.io/centos/centos:stream9

# Build-time Configuration
ARG BUILDTIME \
    VERSION \
    REVISION \
    KEEPALIVE=0 \
    CAP_NET_BIND_SERVICE=0 \
    LANG=C.UTF-8 \
    UMASK=022 \
    DEBUG=false \
    PASSWORDLESS_SUDO=false \
    PGID=0 \
    PUID=0 \
    USER=root \
    WORKDIR=/root

# Standard OCI Metadata (https://github.com/opencontainers/image-spec)
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="CentOS Stream 9 Base Image" \
    org.opencontainers.image.description="Professional Docker Image packaging for CentOS Stream 9. Supports amd64, arm64, ppc64le, s390x." \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/centos" \
    org.opencontainers.image.base.name="snowdreamtech/centos:9" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/centos" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.created="${BUILDTIME}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/centos"

# Runtime Environment Configuration
ENV KEEPALIVE=${KEEPALIVE} \
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PASSWORDLESS_SUDO=${PASSWORDLESS_SUDO} \
    PGID=${PGID} \
    PUID=${PUID} \
    USER=${USER} \
    WORKDIR=${WORKDIR}

# Infrastructure & Tooling Setup
# Includes standard repositories and essential system packages.
RUN set -eux \
    && dnf install -y dnf-plugins-core \
    && dnf config-manager --set-enabled crb \
    && dnf -y --allowerasing install epel-release \
    && dnf -y --allowerasing update \
    && dnf -y --allowerasing install \
    bash \
    zsh \
    nano \
    rsync \
    lsb-release \
    sudo \
    procps-ng \
    vim-enhanced \
    zip \
    unzip \
    bzip2 \
    xz \
    file \
    gzip \
    jq \
    tzdata \
    openssl \
    gnupg2 \
    sysstat \
    wget \
    curl \
    git \
    bind-utils \
    nmap-ncat \
    traceroute \
    iputils \
    net-tools \
    lsof \
    libcap \
    ca-certificates \
    && dnf -y --allowerasing autoremove \
    && dnf -y --allowerasing clean all \
    && rm -rf /var/cache/dnf /tmp/* /var/tmp/*

# gosu Installation with architecture awareness
ENV GOSU_VERSION=1.19
RUN set -eux; \
    rpmArch="$(rpm --query --queryformat='%{ARCH}' rpm)"; \
    case "$rpmArch" in \
        aarch64) dpkgArch='arm64' ;; \
        armv[67]*) dpkgArch='armhf' ;; \
        i[3456]86) dpkgArch='i386' ;; \
        ppc64le) dpkgArch='ppc64el' ;; \
        riscv64 | s390x | loongarch64) dpkgArch="$rpmArch" ;; \
        x86_64) dpkgArch='amd64' ;; \
        *) echo >&2 "error: unknown/unsupported architecture '$rpmArch'"; exit 1 ;; \
    esac; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    chmod +x /usr/local/bin/gosu; \
    gosu --version; \
    gosu nobody true

# System Initialization logic (User mapping, permissions) is handled in entrypoint.d scripts.
# This keeps the Dockerfile clean and the process extensible.

# Container Orchestration Files
COPY vimrc.local /etc/vimrc.local
COPY entrypoint.d /usr/local/bin/entrypoint.d
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Ensure execution bits are correctly set for all entrypoint scripts.
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

# Standard Healthcheck (Verification of core system responsiveness)
HEALTHCHECK NONE

# Process Execution
USER root
WORKDIR /root
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash"]
