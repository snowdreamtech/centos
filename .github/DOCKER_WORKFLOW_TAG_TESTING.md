# Docker Workflow Tag Trigger Testing Guide

## 📋 Overview

This document explains the tag trigger configuration for the Docker multi-platform build workflow and provides testing scenarios to verify the integration with Release-Please.

## 🏷️ Supported Tag Formats

### Primary Format (Release-Please Generated)

The workflow supports Release-Please generated tags:

```yaml
tags:
  - "9-v*" # Matches: 9-v9.0.0, etc.
  - "10-v*" # Matches: 10-v10.0.0, etc.
```

### Legacy Formats (Backward Compatibility)

The workflow maintains backward compatibility with legacy tag formats:

```yaml
tags:
  - "[0-9]+.[0-9]+.[0-9]+" # Matches: 1.2.3, 10.20.30
  - "v[0-9]+.[0-9]+.[0-9]+" # Matches: v1.2.3, v10.20.30
  - "V[0-9]+.[0-9]+.[0-9]+" # Matches: V1.2.3, V10.20.30
  - "centos-*.*.*" # Matches: centos-10.0.0, centos-1.0.0
  - "[0-9]+.[0-9]+" # Matches: 1.2, 10.20
  - "v[0-9]+.[0-9]+" # Matches: v1.2, v10.20
  - "V[0-9]+.[0-9]+" # Matches: V1.2, V10.20
  - "centos-*.*" # Matches: centos-10.0, centos-1.0
  - "[0-9]+" # Matches: 1, 2, 10
  - "v[0-9]+" # Matches: v1, v2, v10
  - "V[0-9]+" # Matches: V1, V2, V10
  - "centos-*" # Matches: centos-10, centos-latest
```

## 🧪 Testing Scenarios

### Scenario 1: Release-Please Tag (Primary Use Case)

**Release-Please Configuration:**

```json
{
  "docker/10": "10.0.0"
}
```

**When you merge a Release-Please PR:**

- Release-Please creates tag: `10-v10.0.0`
- Docker workflow triggers: ✅ YES (matches `10-v*`)
- Matrix job runs: CentOS 10 only
- Generated Docker tags:
  - `snowdreamtech/centos:10-v10.0.0`
  - `snowdreamtech/centos:10-latest`
  - `snowdreamtech/centos:latest` (since 10 is `is_latest: true`)
  - `ghcr.io/snowdreamtech/centos:...` (same tags)

### Scenario 2: Legacy Tag Format

**When you push a legacy tag:**

```bash
git tag 9-v9.0.0
git push origin 9-v9.0.0
```

- Docker workflow triggers: ✅ YES (matches `9-v*`)
- Matrix job runs: CentOS 9 only
- Generated Docker tags:
  - `snowdreamtech/centos:9-v9.0.0`
  - `snowdreamtech/centos:9-latest`
  - `ghcr.io/snowdreamtech/centos:...` (same tags)

### Scenario 3: Manual Workflow Dispatch

You can manually trigger builds for specific versions:

1. Go to **Actions** → **🐳 Docker Multi-Platform Build**
2. Click **Run workflow**
3. Select CentOS version: `9`, `10`, or `all`
4. Choose whether to push images (default: `true`)
5. Click **Run workflow**
