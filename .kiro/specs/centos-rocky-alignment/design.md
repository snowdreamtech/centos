# Design Document: CentOS-Rocky Alignment

## Executive Summary

This design document outlines the technical approach for aligning the CentOS Stream Docker project with the Rocky Linux Docker project structure and standards. The Rocky Linux project serves as the Single Source of Truth (SSoT) for project organization, Dockerfile patterns, entrypoint scripts, and configuration files.

**Scope:** This alignment focuses exclusively on the `docker/` folder structure, Dockerfiles, entrypoint scripts, and configuration files. The `.github/workflows/docker.yml` workflow is already aligned and handles all build, test, security scanning, and deployment automation.

**Key Principle:** Strict alignment with Rocky Linux patterns while documenting legitimate System_Differences between CentOS Stream and Rocky Linux distributions.

## Architecture Overview

### Template-Based Alignment System

```
┌─────────────────────────────────────────────────────────────┐
│                    Rocky Linux Project                       │
│                  (Single Source of Truth)                    │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  docker/8/   │  │  docker/9/   │  │  docker/10/  │     │
│  │  - Dockerfile│  │  - Dockerfile│  │  - Dockerfile│     │
│  │  - entrypoint│  │  - entrypoint│  │  - entrypoint│     │
│  │  - scripts   │  │  - scripts   │  │  - scripts   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  Configuration Files:                                        │
│  - .release-please-config.json                              │
│  - .release-please-manifest.json                            │
│  - package.json                                              │
│  - .github/workflows/docker.yml                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ Copy & Adapt
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   CentOS Stream Project                      │
│                    (Alignment Target)                        │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  docker/8/   │  │  docker/9/   │  │  docker/10/  │     │
│  │  - Dockerfile│  │  - Dockerfile│  │  - Dockerfile│     │
│  │  - entrypoint│  │  - entrypoint│  │  - entrypoint│     │
│  │  - scripts   │  │  - scripts   │  │  - scripts   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  System_Differences Applied:                                 │
│  - Base images: quay.io/centos/centos:stream{8|9|10}       │
│  - OCI labels: CentOS Stream references                     │
│  - Architecture: stream8 (no s390x)                         │
└─────────────────────────────────────────────────────────────┘
```

## Component Design

### 1. Project Structure Design

#### Directory Hierarchy

```
centos/
├── docker/
│   ├── 8/
│   │   ├── Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   ├── entrypoint.d/
│   │   │   └── [modular initialization scripts]
│   │   ├── vimrc.local
│   │   ├── .dockerignore
│   │   └── CHANGELOG.md
│   ├── 9/
│   │   ├── Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   ├── entrypoint.d/
│   │   │   └── [modular initialization scripts]
│   │   ├── vimrc.local
│   │   ├── .dockerignore
│   │   └── CHANGELOG.md
│   └── 10/
│       ├── Dockerfile
│       ├── docker-entrypoint.sh
│       ├── entrypoint.d/
│       │   └── [modular initialization scripts]
│       ├── vimrc.local
│       ├── .dockerignore
│       └── CHANGELOG.md
├── .release-please-config.json
├── .release-please-manifest.json
├── package.json
└── .github/
    └── workflows/
        └── docker.yml (already aligned)
```

**Design Rationale:**
- Mirror Rocky's `docker/{version}/` pattern for consistency
- Each version folder is self-contained with all necessary files
- Modular entrypoint.d/ architecture enables extensible initialization
- Configuration files at project root manage all versions centrally

### 2. Dockerfile Design

#### Base Image Strategy

**Rocky Linux Pattern:**
```dockerfile
FROM rockylinux/rockylinux:8.10
FROM rockylinux/rockylinux:9.7
FROM rockylinux/rockylinux:10.1
```

**CentOS Stream Adaptation:**
```dockerfile
FROM quay.io/centos/centos:stream8
FROM quay.io/centos/centos:stream9
FROM quay.io/centos/centos:stream10
```

**System_Difference Justification:** CentOS Stream uses official Quay.io registry images, while Rocky Linux uses Docker Hub images. This is a distribution-specific difference based on official image hosting.

#### Dockerfile Structure

All Dockerfiles follow this standardized structure from Rocky Linux:

```dockerfile
# 1. Comment Header (Technical Purpose & Design Philosophy)
# 2. FROM Statement (Base Image)
# 3. ARG Declarations (Build-time Configuration)
# 4. LABEL Metadata (OCI Standard Labels)
# 5. ENV Configuration (Runtime Environment)
# 6. RUN Commands (Package Installation & Setup)
# 7. COPY Operations (Entrypoint Scripts & Config Files)
# 8. RUN Permissions (Executable Bits)
# 9. HEALTHCHECK (Container Health Verification)
# 10. USER & WORKDIR (Process Execution Context)
# 11. ENTRYPOINT & CMD (Container Startup)
```

#### ARG Variables (Identical Across Distributions)

```dockerfile
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
```

**Design Rationale:** These ARGs provide flexible build-time configuration and are distribution-agnostic.

#### OCI Metadata Labels

**Template Pattern:**
```dockerfile
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="<Distribution> <Version> Base Image" \
    org.opencontainers.image.description="Professional Docker Image packaging for <Distribution> <Version>. Supports <architectures>." \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/<distribution>" \
    org.opencontainers.image.base.name="snowdreamtech/<distribution>:<version>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/<distribution>" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.created="${BUILDTIME}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/<distribution>"
```

**CentOS-Specific Values:**
- `title`: "CentOS Stream 8 Base Image" (not "Rocky Linux 8 Base Image")
- `description`: Reference "CentOS Stream" instead of "Rocky Linux"
- `documentation`: Point to centos project URLs
- `source`: Point to centos repository
- `base.name`: "snowdreamtech/centos:8" (not "snowdreamtech/rocky:8")

#### Package Installation Logic

**Identical Pattern (Distribution-Agnostic):**
```dockerfile
RUN set -eux \
    && dnf install -y dnf-plugins-core \
    && dnf config-manager --set-enabled <repo> \
    && dnf -y --allowerasing install epel-release \
    && dnf -y --allowerasing update \
    && dnf -y --allowerasing install \
    bash zsh nano rsync sudo procps-ng vim-enhanced \
    zip unzip bzip2 xz file gzip jq tzdata openssl \
    gnupg2 sysstat wget curl git bind-utils nmap-ncat \
    traceroute iputils net-tools lsof libcap ca-certificates \
    && dnf -y --allowerasing autoremove \
    && dnf -y --allowerasing clean all \
    && rm -rf /var/cache/dnf /tmp/* /var/tmp/*
```

**Version-Specific Repository Names:**
- Stream 8: `powertools` (Rocky 8 uses `powertools`)
- Stream 9: `crb` (Rocky 9 uses `crb`)
- Stream 10: `crb` (Rocky 10 uses `crb`)

**Version-Specific Package Names:**
- Stream 8: `redhat-lsb-core` (Rocky 8 uses `redhat-lsb-core`)
- Stream 9: `redhat-lsb-core` (Rocky 9 uses `redhat-lsb-core`)
- Stream 10: `lsb-release` (Rocky 10 uses `lsb-release`)

**System_Difference Documentation:** Add inline comments in Dockerfile when package names differ:
```dockerfile
# CentOS Stream 10 uses lsb-release instead of redhat-lsb-core
lsb-release \
```

#### gosu Installation (Architecture-Aware)

**Identical Logic (Distribution-Agnostic):**
```dockerfile
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
```

**Design Rationale:** gosu enables privilege dropping for security. Architecture detection ensures correct binary for each platform.

### 3. Entrypoint Script Design

#### docker-entrypoint.sh Architecture

**POSIX-Compliant Shell Script (Distribution-Agnostic):**

```sh
#!/bin/sh
# Docker Entrypoint Wrapper
# Purpose: Orchestrates container initialization by executing scripts in entrypoint.d.
# Design:
#   - POSIX compliant for maximum portability
#   - Supports DEBUG=true for verbose logging
#   - Employs 'exec' for graceful shutdown signal forwarding

set -e

# 1. Execute modular initialization scripts
for script in /usr/local/bin/entrypoint.d/*; do
  if [ -x "$script" ]; then
    "$script" "$@"
  fi
done

# 2. Configure working directory
if [ -z "${WORKDIR}" ]; then
  WORKDIR="/root"
fi
cd "${WORKDIR}" 2>/dev/null || true

# 3. Persistence logic for keep-alive containers
if [ "${KEEPALIVE}" = "1" ]; then
  trap : TERM INT
  tail -f /dev/null &
  wait
fi

# 4. Hand over control to main command (PID 1 replacement)
if [ $# -gt 0 ]; then
  if [ "$(id -u)" = "0" ]; then
    exec gosu "${PUID:-0}:${PGID:-0}" "$@"
  else
    exec "$@"
  fi
fi
```

**Key Design Features:**
- **Modular Architecture:** entrypoint.d/ scripts enable extensible initialization
- **POSIX Compliance:** Works across Alpine, Debian, RHEL-based distributions
- **Debug Support:** DEBUG=true enables verbose logging
- **Signal Handling:** exec ensures proper signal forwarding to PID 1
- **Privilege Dropping:** gosu enables running as non-root user
- **Keep-Alive Mode:** KEEPALIVE=1 keeps container running indefinitely

**System_Difference:** None - script is completely distribution-agnostic.

#### entrypoint.d/ Modular Scripts

**Design Pattern:**
- Each script handles a specific initialization concern
- Scripts execute in lexicographical order (00-, 10-, 20-, etc.)
- Scripts are POSIX-compliant shell scripts
- Scripts receive all entrypoint arguments via "$@"

**Common Scripts (from Rocky Linux):**
- User mapping and permission setup
- Environment variable configuration
- Timezone configuration
- Custom initialization hooks

**System_Difference:** None - scripts are distribution-agnostic.

### 4. Architecture Support Configuration

#### Platform Matrix

| Version | Architectures | Justification |
|---------|--------------|---------------|
| Stream 8 | amd64, arm64, ppc64le | Official CentOS Stream 8 support |
| Stream 9 | amd64, arm64, ppc64le, s390x | Official CentOS Stream 9 support |
| Stream 10 | amd64, arm64, ppc64le, s390x | Official CentOS Stream 10 support |

**System_Difference:** Stream 8 lacks s390x support compared to Rocky 8. This is based on official CentOS Stream architecture specifications.

#### docker.yml Platform Configuration

```yaml
platforms: ${{ matrix.version == '8' && 'linux/amd64,linux/arm64,linux/ppc64le' || matrix.version == '9' && 'linux/amd64,linux/arm64,linux/ppc64le,linux/s390x' || matrix.version == '10' && 'linux/amd64,linux/arm64,linux/ppc64le,linux/s390x' || 'linux/amd64,linux/arm64' }}
```

**Design Rationale:** Conditional platform selection based on version ensures correct architecture support per CentOS Stream specifications.

### 5. Release Management Configuration

#### .release-please-config.json Design

**Structure (Identical to Rocky):**
```json
{
  "packages": {
    "docker/8": {
      "release-type": "simple",
      "component": "8",
      "include-component-in-tag": true,
      "changelog-path": "CHANGELOG.md",
      "extra-files": [{"type": "generic", "path": "Dockerfile", "glob": false}]
    },
    "docker/9": { /* same structure */ },
    "docker/10": { /* same structure */ }
  },
  "include-v-in-tag": true,
  "bump-minor-pre-major": true,
  "bump-patch-for-minor-pre-major": true,
  "pull-request-title-pattern": "chore(release): ${component} ${version} 🚀",
  "changelog-sections": [ /* identical to Rocky */ ]
}
```

**System_Difference:** None - configuration is distribution-agnostic.

#### .release-please-manifest.json Design

**Structure:**
```json
{
  "docker/8": "8.0.0",
  "docker/9": "9.0.0",
  "docker/10": "10.0.0"
}
```

**Version Strategy:**
- Use semantic versioning aligned with CentOS Stream major versions
- Start with x.0.0 for initial releases
- release-please will auto-increment based on conventional commits

**System_Difference:** Version numbers reflect CentOS Stream releases, not Rocky Linux releases.

#### package.json Design

**Structure:**
```json
{
  "name": "centos",
  "version": "0.1.0",
  "private": true,
  "description": "Docker Images for CentOS Stream with multi-architecture support",
  "type": "module",
  "devDependencies": {
    "@commitlint/cli": "20.5.0",
    "@commitlint/config-conventional": "20.5.0"
  },
  "packageManager": "pnpm@10.30.3+sha512.c961d1e0a2d8e354ecaa5166b822516668b7f44cb5bd95122d590dd81922f606f5473b6d23ec4a5be05e7fcd18e8488d47d978bbe981872f1145d06e9a740017"
}
```

**System_Differences:**
- `name`: "centos" (not "rocky")
- `description`: Reference "CentOS Stream" (not "Rocky Linux")

### 6. Docker Tag Specification

#### Semantic Versioning Pattern

**Format:** `{major}-v{major}.{minor}.{patch}`

**Examples:**
- Stream 8: `8-v8.0.0`, `8-v8.0.1`, `8-v8.1.0`
- Stream 9: `9-v9.0.0`, `9-v9.0.1`, `9-v9.1.0`
- Stream 10: `10-v10.0.0`, `10-v10.0.1`, `10-v10.1.0`

**Additional Tags (from docker.yml):**
- `{version}-latest`: Latest release for specific version
- `latest`: Latest release across all versions (version 10 only)
- `{version}-nightly`: Nightly builds
- `{version}-YYYYMMDD`: Date-based tags

**Design Rationale:** Version-prefixed tags enable parallel versioning of multiple major versions.

### 7. CI/CD Pipeline Design (Already Implemented)

#### docker.yml Workflow Architecture

**Trigger Events:**
- Push to main/dev branches
- Tag pushes (8-v*, 9-v*, 10-v*)
- Daily schedule (nightly builds)
- Manual workflow_dispatch

**Build Matrix:**
```yaml
matrix:
  include:
    - version: "8"
      base_image: "quay.io/centos/centos:stream8"
      is_latest: false
    - version: "9"
      base_image: "quay.io/centos/centos:stream9"
      is_latest: false
    - version: "10"
      base_image: "quay.io/centos/centos:stream10"
      is_latest: true
```

**Build Steps:**
1. Version filtering (workflow_dispatch support)
2. Security hardening (harden-runner)
3. Disk space optimization
4. Repository checkout
5. Trivy cache setup
6. QEMU emulation (multi-arch)
7. Docker Buildx setup
8. Registry authentication (DockerHub, Quay.io, GHCR)
9. Metadata generation
10. Multi-platform build & push
11. Manifest verification
12. Smoke testing
13. Trivy security scanning
14. SARIF upload (GitHub Security)
15. Cosign image signing
16. Build summary generation

**System_Difference:** Matrix base_image values use CentOS Stream images instead of Rocky Linux images.

### 8. System_Differences Documentation

#### SYSTEM_DIFFERENCES.md Structure

```markdown
# System Differences: CentOS Stream vs Rocky Linux

## Base Images

| Component | Rocky Linux | CentOS Stream | Justification |
|-----------|-------------|---------------|---------------|
| Version 8 | rockylinux/rockylinux:8.10 | quay.io/centos/centos:stream8 | Official distribution sources |
| Version 9 | rockylinux/rockylinux:9.7 | quay.io/centos/centos:stream9 | Official distribution sources |
| Version 10 | rockylinux/rockylinux:10.1 | quay.io/centos/centos:stream10 | Official distribution sources |

## Architecture Support

| Version | Rocky Linux | CentOS Stream | Justification |
|---------|-------------|---------------|---------------|
| 8 | amd64, arm64, ppc64le, s390x | amd64, arm64, ppc64le | Official CentOS Stream 8 specifications |
| 9 | amd64, arm64, ppc64le, s390x | amd64, arm64, ppc64le, s390x | Identical support |
| 10 | amd64, arm64, ppc64le, s390x | amd64, arm64, ppc64le, s390x | Identical support |

## Package Names

| Version | Package | Rocky Linux | CentOS Stream | Justification |
|---------|---------|-------------|---------------|---------------|
| 10 | LSB | redhat-lsb-core | lsb-release | CentOS Stream 10 package naming |

## Repository Names

| Version | Repository | Rocky Linux | CentOS Stream | Justification |
|---------|-----------|-------------|---------------|---------------|
| 8 | Development | powertools | powertools | Identical naming |
| 9 | Development | crb | crb | Identical naming |
| 10 | Development | crb | crb | Identical naming |

## OCI Metadata

All OCI labels reference "CentOS Stream" instead of "Rocky Linux" to accurately represent the distribution.

## Configuration Files

- `.release-please-manifest.json`: Version numbers reflect CentOS Stream releases
- `package.json`: Name and description reference CentOS Stream
```

## Implementation Strategy

### Phase 1: Structure Creation
1. Create `docker/8/`, `docker/9/`, `docker/10/` directories
2. Create `entrypoint.d/` subdirectories
3. Copy supporting files (vimrc.local, .dockerignore)

### Phase 2: Dockerfile Alignment
1. Copy Dockerfiles from Rocky project
2. Replace base images with CentOS Stream equivalents
3. Update OCI labels with CentOS-specific values
4. Add inline comments for System_Differences

### Phase 3: Entrypoint Script Alignment
1. Copy docker-entrypoint.sh (no modifications needed)
2. Copy entrypoint.d/ scripts (no modifications needed)
3. Verify executable permissions

### Phase 4: Configuration Alignment
1. Verify .release-please-config.json (no changes needed)
2. Update .release-please-manifest.json versions
3. Update package.json name and description
4. Verify docker.yml workflow (already aligned)

### Phase 5: Documentation
1. Create SYSTEM_DIFFERENCES.md
2. Document all CentOS-specific variations
3. Provide justifications for each difference

### Phase 6: Verification
1. Verify all version folders have complete structure
2. Verify all Dockerfiles use correct base images
3. Verify all OCI labels reference CentOS Stream
4. Verify configuration files are aligned

## Testing Strategy

**Note:** All testing is handled by the existing `.github/workflows/docker.yml` workflow. No additional test infrastructure is required.

### Automated Testing (via docker.yml)

1. **Build Verification**
   - Multi-platform builds for all architectures
   - Build cache performance analysis
   - Manifest verification

2. **Smoke Testing**
   - Container startup verification
   - Entrypoint execution validation
   - Core tool availability checks
   - Package manager functionality

3. **Security Scanning**
   - Trivy vulnerability scanning
   - SARIF report generation
   - GitHub Security integration

4. **Image Signing**
   - Cosign keyless signing
   - Signature verification
   - Metadata attestation

5. **Multi-Registry Verification**
   - DockerHub push and pull
   - Quay.io push and pull
   - GHCR push and pull

## Quality Assurance

### Linting and Formatting

**Dockerfile Linting:**
```bash
hadolint docker/*/Dockerfile
```

**Shell Script Linting:**
```bash
shellcheck docker/*/docker-entrypoint.sh
shellcheck docker/*/entrypoint.d/*
```

**Markdown Linting:**
```bash
markdownlint '**/*.md'
```

### Conventional Commits Validation

**commitlint Configuration (already in place):**
- Enforces conventional commit format
- Validates commit message structure
- Integrated into CI/CD pipeline

## Security Considerations

### Supply Chain Security

1. **Base Image Verification**
   - Use official CentOS Stream images from Quay.io
   - Verify image signatures when available

2. **Dependency Pinning**
   - gosu version pinned to 1.19
   - GPG key verification for gosu binary

3. **Build Provenance**
   - SLSA provenance attestation (via docker.yml)
   - SBOM generation (CycloneDX format)

4. **Image Signing**
   - Cosign keyless signing with OIDC
   - Signature verification in CI/CD

### Runtime Security

1. **Privilege Dropping**
   - gosu enables running as non-root user
   - PUID/PGID environment variables for user mapping

2. **Minimal Attack Surface**
   - Only essential packages installed
   - Regular security updates via base image

3. **Vulnerability Scanning**
   - Trivy scans on every build
   - Critical vulnerability blocking (configurable)

## Maintenance and Evolution

### Version Lifecycle

1. **New Version Addition**
   - Create `docker/{version}/` directory
   - Copy Dockerfile and scripts from latest version
   - Update base image to new CentOS Stream version
   - Add version to docker.yml matrix
   - Update .release-please-config.json
   - Update .release-please-manifest.json

2. **Version Deprecation**
   - Mark version as deprecated in documentation
   - Continue security updates for grace period
   - Remove from docker.yml matrix after EOL
   - Archive version folder

### Continuous Alignment

1. **Monitoring Rocky Linux Changes**
   - Watch Rocky Linux repository for updates
   - Review Dockerfile changes
   - Review entrypoint script changes
   - Review configuration changes

2. **Applying Updates**
   - Copy changes from Rocky Linux
   - Adapt for CentOS-specific differences
   - Document new System_Differences
   - Test thoroughly before merging

3. **Automated Synchronization**
   - Consider automated diff detection
   - Alert on Rocky Linux repository changes
   - Semi-automated alignment updates

## Conclusion

This design provides a comprehensive blueprint for aligning the CentOS Stream Docker project with Rocky Linux standards while maintaining necessary distribution-specific differences. The template-based approach ensures consistency, the modular architecture enables extensibility, and the automated CI/CD pipeline (docker.yml) handles all testing and deployment without requiring additional infrastructure.

**Key Success Factors:**
- Strict adherence to Rocky Linux patterns
- Clear documentation of System_Differences
- Automated testing via docker.yml
- Semantic versioning and release automation
- Multi-architecture support
- Security-first approach
