# System Differences: CentOS Stream vs Rocky Linux

## Overview

This document catalogs all legitimate differences between the CentOS Stream Docker project and the Rocky Linux Docker project. The Rocky Linux project serves as the reference standard (Single Source of Truth), and the CentOS Stream project aligns with its structure and patterns except where distribution-specific requirements necessitate variations.

**Purpose:** To provide clear justification for every deviation from the Rocky Linux template, ensuring that differences are intentional, documented, and based on legitimate technical requirements rather than alignment oversights.

## Base Images

CentOS Stream and Rocky Linux use different official base images from different registries.

| Version | Rocky Linux | CentOS Stream | Justification |
|---------|-------------|---------------|---------------|
| 8 | `rockylinux/rockylinux:8.10` | `quay.io/centos/centos:stream8` | Official CentOS Stream images are hosted on Quay.io registry, while Rocky Linux uses Docker Hub. CentOS Stream follows a rolling release model without point releases. |
| 9 | `rockylinux/rockylinux:9.7` | `quay.io/centos/centos:stream9` | Official CentOS Stream images are hosted on Quay.io registry, while Rocky Linux uses Docker Hub. CentOS Stream follows a rolling release model without point releases. |
| 10 | `rockylinux/rockylinux:10.1` | `quay.io/centos/centos:stream10` | Official CentOS Stream images are hosted on Quay.io registry, while Rocky Linux uses Docker Hub. CentOS Stream follows a rolling release model without point releases. |

**Technical Impact:**

- Registry location: `quay.io/centos/centos` vs `rockylinux/rockylinux`
- Versioning scheme: CentOS Stream uses `stream{major}` tags (rolling) vs Rocky's point release tags (e.g., `8.10`, `9.7`, `10.1`)
- Update frequency: CentOS Stream images receive continuous updates as the upstream development branch for RHEL

**Implementation:** Each Dockerfile's `FROM` statement reflects the appropriate base image for the distribution. Inline comments document this difference:

```dockerfile
# Base image difference: CentOS Stream uses quay.io/centos/centos:stream8 instead of rockylinux/rockylinux:8.10
FROM quay.io/centos/centos:stream8
```

## Architecture Support

CentOS Stream 8 has different architecture support compared to Rocky Linux 8 and later versions.

| Version | Rocky Linux | CentOS Stream | Justification |
|---------|-------------|---------------|---------------|
| 8 | amd64, arm64, ppc64le, s390x | amd64, arm64, ppc64le | CentOS Stream 8 does not officially support s390x architecture. This is based on official CentOS Stream 8 architecture specifications. |
| 9 | amd64, arm64, ppc64le, s390x | amd64, arm64, ppc64le, s390x | Identical architecture support across both distributions. |
| 10 | amd64, arm64, ppc64le, s390x | amd64, arm64, ppc64le, s390x | Identical architecture support across both distributions. |

**Technical Impact:**

- Version 8 builds target 3 architectures instead of 4
- CI/CD pipeline uses conditional platform selection based on version
- OCI image description for version 8 lists 3 architectures instead of 4

**Implementation:** The `.github/workflows/docker.yml` workflow uses conditional logic to select appropriate platforms:

```yaml
platforms: ${{ matrix.version == '8' && 'linux/amd64,linux/arm64,linux/ppc64le' || matrix.version == '9' && 'linux/amd64,linux/arm64,linux/ppc64le,linux/s390x' || matrix.version == '10' && 'linux/amd64,linux/arm64,linux/ppc64le,linux/s390x' || 'linux/amd64,linux/arm64' }}
```

Dockerfile OCI labels reflect accurate architecture support:

- Version 8: `"Supports amd64, arm64, ppc64le."`
- Version 9: `"Supports amd64, arm64, ppc64le, s390x."`
- Version 10: `"Supports amd64, arm64, ppc64le, s390x."`

## OCI Metadata Labels

All OCI metadata labels reference "CentOS Stream" instead of "Rocky Linux" to accurately represent the distribution.

| Label | Rocky Linux Value | CentOS Stream Value | Justification |
|-------|-------------------|---------------------|---------------|
| `org.opencontainers.image.title` | "Rocky Linux {version} Base Image" | "CentOS Stream {version} Base Image" | Accurate distribution identification |
| `org.opencontainers.image.description` | "Professional Docker Image packaging for Rocky Linux {version}..." | "Professional Docker Image packaging for CentOS Stream {version}..." | Accurate distribution identification |
| `org.opencontainers.image.documentation` | `https://hub.docker.com/r/snowdreamtech/rocky` | `https://hub.docker.com/r/snowdreamtech/centos` | Project-specific documentation URL |
| `org.opencontainers.image.base.name` | `snowdreamtech/rocky:{version}` | `snowdreamtech/centos:{version}` | Project-specific image naming |
| `org.opencontainers.image.source` | `https://github.com/snowdreamtech/rocky` | `https://github.com/snowdreamtech/centos` | Project-specific repository URL |
| `org.opencontainers.image.url` | `https://github.com/snowdreamtech/rocky` | `https://github.com/snowdreamtech/centos` | Project-specific repository URL |

**Technical Impact:**

- Container inspection tools display correct distribution information
- Image metadata accurately reflects the underlying operating system
- Documentation and source links point to the correct project resources

**Implementation:** All Dockerfiles include updated OCI labels with CentOS-specific values while maintaining the same label structure as Rocky Linux.

## Package Names

Both distributions use identical package names across all versions. No package name differences have been identified.

| Version | Package Category | Rocky Linux | CentOS Stream | Status |
|---------|-----------------|-------------|---------------|--------|
| 8 | LSB | `redhat-lsb-core` | `redhat-lsb-core` | Identical |
| 9 | LSB | `redhat-lsb-core` | `redhat-lsb-core` | Identical |
| 10 | LSB | `lsb-release` | `lsb-release` | Identical |
| All | Core utilities | (same package list) | (same package list) | Identical |

**Note:** The design document anticipated potential package name differences (e.g., `redhat-lsb-core` vs `lsb-release` for version 10), but actual implementation shows both distributions use the same package names for each version.

## Repository Names

Both distributions use identical repository names for enabling additional package sources.

| Version | Repository Type | Rocky Linux | CentOS Stream | Status |
|---------|----------------|-------------|---------------|--------|
| 8 | Development Tools | `powertools` | `powertools` | Identical |
| 9 | Development Tools | `crb` (CodeReady Builder) | `crb` (CodeReady Builder) | Identical |
| 10 | Development Tools | `crb` (CodeReady Builder) | `crb` (CodeReady Builder) | Identical |

**Technical Impact:** No differences in repository configuration commands between distributions.

**Implementation:** Dockerfiles use identical `dnf config-manager` commands across both projects.

## Configuration Files

Configuration files are largely identical with only project-specific naming differences.

### .release-please-config.json

**Status:** Identical structure and configuration. No differences.

**Justification:** Release management configuration is distribution-agnostic.

### .release-please-manifest.json

**Differences:**

- Version numbers reflect CentOS Stream release versions
- Path structure is identical: `docker/{version}` format

**Justification:** Version numbers must align with the actual CentOS Stream releases being packaged.

### package.json

**Differences:**

| Field | Rocky Linux | CentOS Stream | Justification |
|-------|-------------|---------------|---------------|
| `name` | `"rocky"` | `"centos"` | Project-specific identifier |
| `description` | "Docker Images for Rocky Linux..." | "Docker Images for CentOS Stream..." | Accurate project description |

**Justification:** Package metadata must accurately identify the project while maintaining identical dependency and tooling configuration.

### .github/workflows/docker.yml

**Differences:**

- Matrix `base_image` values use CentOS Stream images
- Platform configuration for version 8 excludes s390x
- Image names reference `snowdreamtech/centos` instead of `snowdreamtech/rocky`

**Justification:** Workflow must build and push images for the correct distribution with appropriate architecture support.

## Entrypoint Scripts

All entrypoint scripts (`docker-entrypoint.sh` and `entrypoint.d/*`) are completely identical between distributions.

**Status:** No differences.

**Justification:** Entrypoint initialization logic is distribution-agnostic and operates at the container runtime level, independent of the underlying operating system distribution.

## Supporting Files

Supporting files are identical between distributions.

| File | Status | Justification |
|------|--------|---------------|
| `vimrc.local` | Identical | Editor configuration is distribution-agnostic |
| `.dockerignore` | Identical | Build context exclusions are distribution-agnostic |
| `CHANGELOG.md` | Identical structure | Changelog format follows same conventions |

## Summary of Differences

### Critical Differences (Require Different Values)

1. **Base Images:** Different registry and versioning scheme
2. **Architecture Support (v8 only):** CentOS Stream 8 lacks s390x
3. **OCI Metadata:** Distribution-specific labels and URLs
4. **Configuration Naming:** Project-specific identifiers in package.json

### Identical Components (No Differences)

1. **Dockerfile Structure:** Same ARG declarations, ENV configuration, RUN commands
2. **Package Installation:** Same package lists and installation logic
3. **Repository Configuration:** Same repository names and enablement commands
4. **Entrypoint Scripts:** Completely identical initialization logic
5. **Release Configuration:** Same release-please structure and conventions
6. **Supporting Files:** Same vimrc.local, .dockerignore, and other files

## Maintenance Guidelines

### When Syncing from Rocky Linux

1. **Always Copy:** Entrypoint scripts, supporting files, release configuration structure
2. **Adapt Base Images:** Replace Rocky base images with CentOS Stream equivalents
3. **Update OCI Labels:** Change distribution references from "Rocky Linux" to "CentOS Stream"
4. **Verify Architecture:** Ensure version 8 excludes s390x platform
5. **Check Package Names:** Verify package availability in CentOS Stream repositories (though historically identical)
6. **Update Documentation:** Document any new differences discovered during sync

### Validation Checklist

- [ ] Base images use `quay.io/centos/centos:stream{version}` format
- [ ] OCI labels reference "CentOS Stream" and centos project URLs
- [ ] Version 8 Dockerfile description lists 3 architectures (not 4)
- [ ] Version 9 and 10 Dockerfile descriptions list 4 architectures
- [ ] docker.yml workflow uses correct platform configuration for each version
- [ ] package.json name field is "centos"
- [ ] All entrypoint scripts are identical to Rocky Linux
- [ ] All inline comments document base image differences

## Conclusion

The CentOS Stream Docker project maintains strict alignment with Rocky Linux patterns while accommodating four categories of legitimate differences:

1. **Distribution Identity:** Base images, OCI labels, and project naming
2. **Architecture Support:** Version 8 platform limitations
3. **Registry Location:** Quay.io vs Docker Hub hosting
4. **Versioning Scheme:** Rolling stream releases vs point releases

All other aspects—including Dockerfile structure, package installation logic, entrypoint scripts, release configuration, and supporting files—remain identical to ensure consistency, maintainability, and adherence to best practices across both projects.
