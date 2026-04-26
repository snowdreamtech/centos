# Implementation Plan: CentOS-Rocky Alignment

## Overview

This implementation plan transforms the CentOS Stream Docker project to align with the Rocky Linux Docker project structure, standards, and implementation patterns. The Rocky Linux project serves as the reference standard. All alignment work will be performed on the `dev` branch with atomic commits following Conventional Commits format.

**Scope:** This implementation focuses solely on aligning the docker/ folder structure, Dockerfiles, entrypoint scripts, and configuration files to match Rocky Linux patterns. The docker.yml workflow is already aligned and requires no changes.

## Tasks

- [x] 1. Create docker/ folder structure for all versions
  - [x] 1.1 Create version folders
    - Create `docker/8/` directory
    - Create `docker/9/` directory
    - Create `docker/10/` directory
    - _Requirements: 1.2, 1.3_

  - [x] 1.2 Create entrypoint.d directories
    - Create `docker/8/entrypoint.d/` directory
    - Create `docker/9/entrypoint.d/` directory
    - Create `docker/10/entrypoint.d/` directory
    - _Requirements: 1.4_

  - [x] 1.3 Create supporting files for each version
    - Copy `vimrc.local` from Rocky to each version folder
    - Copy `.dockerignore` from Rocky to each version folder
    - Create empty `CHANGELOG.md` in each version folder
    - _Requirements: 1.4, 20.4_

- [x] 2. Align Dockerfile for version 8
  - Copy `docker/8/Dockerfile` from Rocky project
  - Replace base image: `rockylinux/rockylinux:8.10` → `quay.io/centos/centos:stream8`
  - Update OCI labels: Change "Rocky Linux" references to "CentOS Stream"
  - Update image title to "CentOS Stream 8 Base Image"
  - Update image description to reference CentOS Stream 8
  - Update documentation URL to centos project
  - Update source URL to centos project
  - Add inline comment documenting base image difference
  - Verify architecture support matches: amd64, arm64, ppc64le (no s390x for version 8)
  - _Requirements: 3.1, 3.4, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 4.1_

- [x] 3. Align entrypoint scripts for version 8
  - Copy `docker/8/docker-entrypoint.sh` from Rocky project (no changes needed - script is distribution-agnostic)
  - Copy all scripts from `docker/8/entrypoint.d/` from Rocky project (no changes needed)
  - Verify all scripts have executable permissions
  - _Requirements: 7.1, 7.2, 7.3, 8.1, 8.2, 8.3, 8.4_

- [x] 4. Align Dockerfile for version 9
  - Copy `docker/9/Dockerfile` from Rocky project
  - Replace base image: `rockylinux/rockylinux:9.7` → `quay.io/centos/centos:stream9`
  - Update OCI labels: Change "Rocky Linux" references to "CentOS Stream"
  - Update image title to "CentOS Stream 9 Base Image"
  - Update image description to reference CentOS Stream 9
  - Update documentation URL to centos project
  - Update source URL to centos project
  - Add inline comment documenting base image difference
  - Verify architecture support matches: amd64, arm64, ppc64le, s390x
  - _Requirements: 3.2, 3.4, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 4.2_

- [x] 5. Align entrypoint scripts for version 9
  - Copy `docker/9/docker-entrypoint.sh` from Rocky project (no changes needed - script is distribution-agnostic)
  - Copy all scripts from `docker/9/entrypoint.d/` from Rocky project (no changes needed)
  - Verify all scripts have executable permissions
  - _Requirements: 7.1, 7.2, 7.3, 8.1, 8.2, 8.3, 8.4_

- [x] 6. Align Dockerfile for version 10
  - Copy `docker/10/Dockerfile` from Rocky project
  - Replace base image: `rockylinux/rockylinux:10.1` → `quay.io/centos/centos:stream10`
  - Update OCI labels: Change "Rocky Linux" references to "CentOS Stream"
  - Update image title to "CentOS Stream 10 Base Image"
  - Update image description to reference CentOS Stream 10
  - Update documentation URL to centos project
  - Update source URL to centos project
  - Add inline comment documenting base image difference
  - Verify architecture support matches: amd64, arm64, ppc64le, s390x
  - _Requirements: 3.3, 3.4, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 4.3_

- [x] 7. Align entrypoint scripts for version 10
  - Copy `docker/10/docker-entrypoint.sh` from Rocky project (no changes needed - script is distribution-agnostic)
  - Copy all scripts from `docker/10/entrypoint.d/` from Rocky project (no changes needed)
  - Verify all scripts have executable permissions
  - _Requirements: 7.1, 7.2, 7.3, 8.1, 8.2, 8.3, 8.4_

- [x] 8. Align .release-please-config.json
  - Copy `.release-please-config.json` from Rocky project
  - Verify packages are defined for docker/8, docker/9, docker/10
  - Verify release-type, component naming, and changelog configuration match Rocky
  - Verify changelog-sections array matches Rocky
  - Verify pull-request-title-pattern and pull-request-header match Rocky
  - No changes needed - configuration is distribution-agnostic
  - _Requirements: 9.1, 9.2, 9.3, 9.4_

- [x] 9. Align .release-please-manifest.json
  - Copy `.release-please-manifest.json` from Rocky project
  - Update version entries to appropriate CentOS Stream starting versions:
    - `docker/8`: Set to appropriate CentOS Stream 8 version
    - `docker/9`: Set to appropriate CentOS Stream 9 version
    - `docker/10`: Set to appropriate CentOS Stream 10 version
  - Verify path structure matches Rocky: docker/{version} format
  - _Requirements: 10.1, 10.2, 10.3_

- [x] 10. Align package.json
  - Copy `package.json` from Rocky project
  - Update name field to "centos"
  - Update description to reference CentOS Stream instead of Rocky Linux
  - Verify devDependencies match Rocky (@commitlint/cli, @commitlint/config-conventional)
  - Verify packageManager specification matches Rocky
  - _Requirements: 11.1, 11.2, 11.3, 11.4_

- [x] 11. Verify docker.yml workflow alignment
  - Confirm `.github/workflows/docker.yml` exists and matches Rocky project
  - Verify workflow references correct image names (snowdreamtech/centos)
  - Verify matrix includes versions 8, 9, 10 with correct base images
  - Verify architecture support per version (8: amd64/arm64/ppc64le, 9/10: +s390x)
  - Note: docker.yml appears already aligned, verify no changes needed
  - _Requirements: 27.1, 27.2, 27.3, 29.1, 29.2, 29.3, 29.4_

- [x] 12. Create System_Differences documentation
  - Create `SYSTEM_DIFFERENCES.md` documenting CentOS-specific variations
  - Document base image differences (quay.io/centos/centos vs rockylinux/rockylinux)
  - Document architecture support differences (version 8 lacks s390x)
  - Document any package or repository name differences
  - _Requirements: 17.2, 17.4_

- [x] 13. Final verification
  - Verify all version folders (8, 9, 10) have complete structure
  - Verify all Dockerfiles use correct CentOS Stream base images
  - Verify all OCI labels reference CentOS Stream (not Rocky Linux)
  - Verify all configuration files are aligned
  - Verify docker.yml workflow is aligned
  - _Requirements: 20.1, 20.2, 20.3, 20.4, 17.1, 17.3_

## Notes

- All tasks reference specific requirements for traceability
- Each task is independently executable with clear deliverables
- System_Differences are documented to justify legitimate variations from Rocky Linux
- All work is performed on the dev branch with atomic commits
- Commits follow Conventional Commits format
- The docker.yml workflow file is already aligned and handles all build, test, and deployment automation
- No additional testing or CI/CD configuration is needed beyond what docker.yml provides
