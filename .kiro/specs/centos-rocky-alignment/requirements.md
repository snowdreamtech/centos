# Requirements Document

## Introduction

This document defines the requirements for aligning the CentOS Stream Docker project with the Rocky Linux Docker project structure, standards, and implementation patterns. The Rocky Linux project serves as the reference standard, and the CentOS Stream project will be refactored to match its architecture, coding conventions, and operational patterns while accounting for legitimate system-specific differences between CentOS Stream and Rocky Linux distributions.

The alignment ensures consistency, maintainability, and adherence to best practices across both projects, enabling streamlined development workflows and unified quality standards.

## Glossary

- **Rocky_Project**: The Rocky Linux Docker project located in the `rocky/` workspace, serving as the reference standard and template for alignment.
- **CentOS_Project**: The CentOS Stream Docker project located in the `centos/` workspace, which will be refactored to align with Rocky_Project.
- **Version_Folder**: A directory representing a specific major version of the operating system (e.g., `8/`, `9/`, `10/`).
- **Base_Image**: The official container image used as the foundation in a Dockerfile FROM statement.
- **Semantic_Tag**: A three-part version identifier following the pattern `{major}-v{major}.{minor}.{patch}` (e.g., `8-v8.0.0`).
- **Architecture**: The CPU architecture supported by a container image (e.g., amd64, arm64, ppc64le, s390x).
- **Entrypoint_Script**: A shell script executed when a container starts, responsible for initialization logic.
- **Release_Please**: An automated release management tool that generates changelogs and manages version bumping.
- **Conventional_Commits**: A standardized commit message format following the specification at conventionalcommits.org.
- **System_Difference**: A legitimate variation between CentOS Stream and Rocky Linux that requires different configuration or implementation (e.g., base image URLs, repository names, package availability).
- **Alignment_Deviation**: Any difference between CentOS_Project and Rocky_Project that is not justified by a System_Difference and must be corrected.
- **Workspace_Root**: The root directory of the CentOS_Project where all relative paths are resolved.
- **AI_Rules**: The set of development standards and guidelines defined in `.agent/rules/` that govern AI-assisted development behavior.
- **Linter**: An automated code analysis tool that checks for syntax errors, style violations, and potential bugs.
- **Formatter**: An automated tool that enforces consistent code style by reformatting source files.

## Requirements

### Requirement 1: Project Structure Initialization

**User Story:** As a developer, I want the CentOS_Project to be initialized on the dev branch with a foundational structure, so that all subsequent alignment work has a stable base.

#### Acceptance Criteria

1. THE CentOS_Project SHALL use the `dev` branch as the base for all alignment work
2. WHEN the alignment begins, THE CentOS_Project SHALL contain Version_Folders for versions 8, 9, and 10
3. THE CentOS_Project SHALL maintain a directory structure that mirrors Rocky_Project's organization pattern
4. WHEN a Version_Folder is created, THE Version_Folder SHALL contain subdirectories and files matching Rocky_Project's structure (Dockerfile, docker-entrypoint.sh, entrypoint.d/, CHANGELOG.md, vimrc.local, .dockerignore, .gitkeep)

### Requirement 2: Reference Standard Analysis

**User Story:** As a developer, I want to analyze the Rocky_Project as the reference template, so that I can identify all structural patterns, conventions, and best practices to replicate in CentOS_Project.

#### Acceptance Criteria

1. THE Analysis_Process SHALL document all structural patterns from Rocky_Project including directory hierarchy, file naming conventions, and configuration file formats
2. THE Analysis_Process SHALL identify all coding conventions used in Rocky_Project including comment styles, variable naming, and script organization
3. THE Analysis_Process SHALL catalog all best practices from Rocky_Project including error handling patterns, logging approaches, and security measures
4. WHEN System_Differences are identified, THE Analysis_Process SHALL document them with justification for why they differ between CentOS Stream and Rocky Linux

### Requirement 3: Base Image Configuration

**User Story:** As a developer, I want to use official CentOS Stream base images in all Dockerfiles, so that the containers are built on verified, supported foundations.

#### Acceptance Criteria

1. WHEN Version_Folder 8 is configured, THE Dockerfile SHALL use `quay.io/centos/centos:stream8` as the Base_Image
2. WHEN Version_Folder 9 is configured, THE Dockerfile SHALL use `quay.io/centos/centos:stream9` as the Base_Image
3. WHEN Version_Folder 10 is configured, THE Dockerfile SHALL use `quay.io/centos/centos:stream10` as the Base_Image
4. THE Dockerfile SHALL follow the same structural pattern as Rocky_Project Dockerfiles including comment headers, ARG declarations, LABEL metadata, ENV configuration, RUN commands, COPY operations, and final CMD/ENTRYPOINT declarations

### Requirement 4: Architecture Support Configuration

**User Story:** As a developer, I want to configure architecture support based on official CentOS Stream specifications, so that the images are built for all supported platforms.

#### Acceptance Criteria

1. WHEN Version_Folder 8 is configured, THE Architecture_Configuration SHALL support amd64, arm64, and ppc64le
2. WHEN Version_Folder 9 is configured, THE Architecture_Configuration SHALL support amd64, arm64, ppc64le, and s390x
3. WHEN Version_Folder 10 is configured, THE Architecture_Configuration SHALL support amd64, arm64, ppc64le, and s390x
4. THE Architecture_Configuration SHALL be implemented in the same manner as Rocky_Project using architecture-aware installation logic in Dockerfiles

### Requirement 5: Docker Tag Specification

**User Story:** As a developer, I want to implement three-part semantic versioning for Docker tags, so that image versions are clear and follow industry standards.

#### Acceptance Criteria

1. THE Semantic_Tag SHALL follow the pattern `{major}-v{major}.{minor}.{patch}` where major corresponds to the CentOS Stream version
2. WHEN Version_Folder 8 is tagged, THE Semantic_Tag SHALL begin with `8-v8.`
3. WHEN Version_Folder 9 is tagged, THE Semantic_Tag SHALL begin with `9-v9.`
4. WHEN Version_Folder 10 is tagged, THE Semantic_Tag SHALL begin with `10-v10.`
5. THE Semantic_Tag SHALL match the tagging convention used in Rocky_Project

### Requirement 6: Dockerfile Content Alignment

**User Story:** As a developer, I want Dockerfile content to align with Rocky_Project standards, so that both projects maintain consistent container build patterns.

#### Acceptance Criteria

1. THE Dockerfile SHALL include identical comment headers explaining technical purpose and design philosophy as Rocky_Project
2. THE Dockerfile SHALL declare the same ARG variables as Rocky_Project (BUILDTIME, VERSION, REVISION, KEEPALIVE, CAP_NET_BIND_SERVICE, LANG, UMASK, DEBUG, PASSWORDLESS_SUDO, PGID, PUID, USER, WORKDIR)
3. THE Dockerfile SHALL include OCI metadata labels matching Rocky_Project's label structure with CentOS-specific values
4. THE Dockerfile SHALL install the same system packages as Rocky_Project except where System_Differences require different package names or availability
5. THE Dockerfile SHALL implement gosu installation with identical architecture-aware logic as Rocky_Project
6. WHEN a System_Difference requires different package names, THE Dockerfile SHALL document the difference with an inline comment explaining the CentOS-specific requirement

### Requirement 7: Entrypoint Script Alignment

**User Story:** As a developer, I want docker-entrypoint.sh to align with Rocky_Project, so that container initialization behavior is consistent across both projects.

#### Acceptance Criteria

1. THE docker-entrypoint.sh SHALL implement the same initialization logic as Rocky_Project including environment variable handling, user mapping, and entrypoint.d script execution
2. THE docker-entrypoint.sh SHALL use identical error handling patterns as Rocky_Project
3. THE docker-entrypoint.sh SHALL maintain the same script structure and organization as Rocky_Project
4. WHEN System_Differences require different initialization logic, THE docker-entrypoint.sh SHALL document the difference with inline comments

### Requirement 8: Entrypoint.d Scripts Alignment

**User Story:** As a developer, I want all scripts in entrypoint.d/ to align with Rocky_Project, so that modular initialization components are consistent.

#### Acceptance Criteria

1. THE entrypoint.d directory SHALL contain the same script files as Rocky_Project
2. WHEN a script exists in Rocky_Project entrypoint.d, THE corresponding script in CentOS_Project SHALL implement identical logic except where System_Differences require variations
3. THE entrypoint.d scripts SHALL follow the same naming convention as Rocky_Project
4. THE entrypoint.d scripts SHALL maintain the same execution order as Rocky_Project

### Requirement 9: Release Please Configuration Alignment

**User Story:** As a developer, I want .release-please-config.json to align with Rocky_Project, so that automated release management follows the same patterns.

#### Acceptance Criteria

1. THE .release-please-config.json SHALL define packages for docker/8, docker/9, and docker/10 matching Rocky_Project's package structure
2. THE .release-please-config.json SHALL use the same release-type, component naming, and changelog configuration as Rocky_Project
3. THE .release-please-config.json SHALL include identical changelog-sections as Rocky_Project
4. THE .release-please-config.json SHALL use the same pull-request-title-pattern and pull-request-header as Rocky_Project

### Requirement 10: Release Please Manifest Alignment

**User Story:** As a developer, I want .release-please-manifest.json to align with Rocky_Project structure, so that version tracking follows the same organizational pattern.

#### Acceptance Criteria

1. THE .release-please-manifest.json SHALL define version entries for docker/8, docker/9, and docker/10
2. THE .release-please-manifest.json SHALL use the same path structure as Rocky_Project (docker/{version} format)
3. WHEN initial versions are set, THE .release-please-manifest.json SHALL use appropriate starting versions for CentOS Stream releases

### Requirement 11: Package.json Alignment

**User Story:** As a developer, I want package.json to align with Rocky_Project, so that project metadata and dependencies are consistent.

#### Acceptance Criteria

1. THE package.json SHALL use "centos" as the name field
2. THE package.json SHALL include the same description pattern as Rocky_Project adapted for CentOS Stream
3. THE package.json SHALL declare the same devDependencies as Rocky_Project including @commitlint/cli and @commitlint/config-conventional
4. THE package.json SHALL use the same packageManager specification as Rocky_Project

### Requirement 12: Conventional Commits Compliance

**User Story:** As a developer, I want all commit messages to follow Conventional Commits format, so that the project maintains a clean, parseable Git history.

#### Acceptance Criteria

1. THE Commit_Message SHALL follow the format `<type>(<scope>): <description>` as defined in the Conventional Commits specification
2. THE Commit_Message SHALL use only allowed types (feat, fix, docs, style, refactor, test, chore, ci, perf, build, revert)
3. THE Commit_Message header SHALL be written in English using imperative mood
4. THE Commit_Message header SHALL not exceed 120 characters
5. THE Commit_Message header SHALL not end with a period

### Requirement 13: Atomic Commit Strategy

**User Story:** As a developer, I want each logical change to be an independent commit, so that the Git history is granular and easy to review.

#### Acceptance Criteria

1. WHEN a logical change is completed, THE Change SHALL be committed as a single atomic unit
2. THE Commit SHALL not bundle unrelated changes together
3. THE Commit SHALL not leave the repository in a broken or inconsistent state
4. WHEN multiple changes are implemented in sequence, THE Implementation SHALL create separate commits for each logical change

### Requirement 14: Auto-commit Without Push

**User Story:** As a developer, I want commits to be created automatically but not pushed, so that I retain control over when changes are shared to the remote repository.

#### Acceptance Criteria

1. WHEN a logical change is completed, THE System SHALL automatically create a Git commit
2. THE System SHALL not automatically push commits to the remote repository
3. THE Developer SHALL retain manual control over git push operations
4. THE Commit SHALL pass all pre-commit hooks before being created

### Requirement 15: Cross-platform Compatibility

**User Story:** As a developer, I want all scripts to work on Linux, macOS, and Windows, so that contributors can work on any platform.

#### Acceptance Criteria

1. THE Scripts SHALL execute successfully on Linux operating systems
2. THE Scripts SHALL execute successfully on macOS operating systems
3. THE Scripts SHALL execute successfully on Windows operating systems
4. WHEN shell scripts are required, THE Project SHALL provide three variants (.sh for POSIX, .ps1 for PowerShell, .bat for CMD) following the Cross-Platform Shell Delegation Pattern
5. THE Scripts SHALL use relative paths resolved from Workspace_Root and SHALL not contain absolute paths starting with /Users/, C:\, or ~

### Requirement 16: AI Rules Compliance

**User Story:** As a developer, I want all AI-assisted development to follow the rules in .agent/rules/, so that code generation and modifications meet project standards.

#### Acceptance Criteria

1. THE AI_Agent SHALL read and follow all rules defined in .agent/rules/ before executing any task
2. THE AI_Agent SHALL apply language-specific rules from .agent/rules/ when working with code in that language
3. THE AI_Agent SHALL apply framework-specific rules from .agent/rules/ when working with code using that framework
4. THE AI_Agent SHALL apply infrastructure-specific rules from .agent/rules/ when working with Docker, CI/CD, or deployment configurations

### Requirement 17: Content Alignment with System Differences

**User Story:** As a developer, I want content to strictly align with Rocky_Project while allowing for legitimate System_Differences, so that the projects are consistent where possible and different only where necessary.

#### Acceptance Criteria

1. THE CentOS_Project SHALL align with Rocky_Project for all content except where System_Differences require variations
2. WHEN a System_Difference exists, THE Difference SHALL be documented with an inline comment or documentation entry explaining the CentOS-specific requirement
3. THE Alignment_Process SHALL identify and correct all Alignment_Deviations that are not justified by System_Differences
4. THE Documentation SHALL maintain a list of all System_Differences with justifications

### Requirement 18: Lint and Format Validation

**User Story:** As a developer, I want all code to pass linting and formatting checks, so that the project maintains consistent quality standards.

#### Acceptance Criteria

1. THE Code SHALL pass all Linter checks defined in the project configuration
2. THE Code SHALL pass all Formatter checks defined in the project configuration
3. WHEN a Linter or Formatter identifies an issue, THE Issue SHALL be corrected before committing
4. THE Linter and Formatter configurations SHALL match Rocky_Project's quality standards

### Requirement 19: Workspace Path Resolution

**User Story:** As a developer, I want all paths to be correctly resolved relative to the centos workspace directory, so that scripts and configurations work regardless of where the repository is cloned.

#### Acceptance Criteria

1. THE Scripts SHALL resolve all paths relative to Workspace_Root
2. THE Configuration_Files SHALL use relative paths from Workspace_Root
3. THE Documentation SHALL reference paths relative to Workspace_Root
4. THE Scripts SHALL not assume any specific parent directory structure above Workspace_Root

### Requirement 20: Version Folder Consistency

**User Story:** As a developer, I want all Version_Folders to maintain consistent structure and content, so that each version is organized identically.

#### Acceptance Criteria

1. WHEN Version_Folder 8 is configured, THE Structure SHALL match Version_Folders 9 and 10 except where version-specific System_Differences require variations
2. WHEN Version_Folder 9 is configured, THE Structure SHALL match Version_Folders 8 and 10 except where version-specific System_Differences require variations
3. WHEN Version_Folder 10 is configured, THE Structure SHALL match Version_Folders 8 and 9 except where version-specific System_Differences require variations
4. THE Version_Folders SHALL all follow the same organizational pattern as Rocky_Project Version_Folders

### Requirement 21: Configuration File Parser and Validator

**User Story:** As a developer, I want to parse and validate configuration files (.release-please-config.json, .release-please-manifest.json, package.json), so that I can ensure they are syntactically correct and semantically aligned with Rocky_Project.

#### Acceptance Criteria

1. WHEN a configuration file is provided, THE Parser SHALL parse it into a structured object representation
2. WHEN an invalid configuration file is provided, THE Parser SHALL return a descriptive error indicating the syntax or schema violation
3. THE Validator SHALL verify that parsed configuration matches Rocky_Project's schema and conventions
4. FOR ALL valid configuration objects, parsing then serializing then parsing SHALL produce an equivalent object (round-trip property)

### Requirement 22: Dockerfile Parser and Validator

**User Story:** As a developer, I want to parse and validate Dockerfiles, so that I can ensure they follow Rocky_Project patterns and contain all required elements.

#### Acceptance Criteria

1. WHEN a Dockerfile is provided, THE Parser SHALL parse it into a structured representation of instructions (FROM, ARG, LABEL, ENV, RUN, COPY, ENTRYPOINT, CMD)
2. WHEN an invalid Dockerfile is provided, THE Parser SHALL return a descriptive error indicating the syntax violation
3. THE Validator SHALL verify that the Dockerfile contains all required instructions matching Rocky_Project's pattern
4. THE Validator SHALL verify that Base_Image URLs are correct for the corresponding CentOS Stream version

### Requirement 23: Shell Script Parser and Validator

**User Story:** As a developer, I want to parse and validate shell scripts (docker-entrypoint.sh, entrypoint.d/*), so that I can ensure they follow Rocky_Project patterns and are syntactically correct.

#### Acceptance Criteria

1. WHEN a shell script is provided, THE Parser SHALL parse it into a structured representation of commands and control flow
2. WHEN an invalid shell script is provided, THE Parser SHALL return a descriptive error indicating the syntax violation
3. THE Validator SHALL verify that the script follows POSIX shell conventions as used in Rocky_Project
4. THE Validator SHALL verify that the script includes proper error handling patterns matching Rocky_Project

### Requirement 24: Alignment Difference Detector

**User Story:** As a developer, I want to detect differences between CentOS_Project and Rocky_Project, so that I can identify Alignment_Deviations that need correction.

#### Acceptance Criteria

1. WHEN comparing two files, THE Detector SHALL identify all structural differences including missing sections, extra sections, and content variations
2. WHEN a difference is detected, THE Detector SHALL classify it as either a System_Difference (justified) or an Alignment_Deviation (requires correction)
3. THE Detector SHALL generate a report listing all Alignment_Deviations with file locations and descriptions
4. THE Detector SHALL support comparison of Dockerfiles, shell scripts, JSON configuration files, and markdown documentation

### Requirement 25: Migration Script Generator

**User Story:** As a developer, I want to generate migration scripts that transform CentOS_Project files to match Rocky_Project patterns, so that alignment can be partially automated.

#### Acceptance Criteria

1. WHEN an Alignment_Deviation is identified, THE Generator SHALL produce a migration script that corrects the deviation
2. THE Migration_Script SHALL preserve System_Differences while correcting Alignment_Deviations
3. THE Migration_Script SHALL be idempotent (running it multiple times produces the same result as running it once)
4. THE Migration_Script SHALL include comments explaining each transformation

### Requirement 26: Documentation Synchronization

**User Story:** As a developer, I want documentation to be synchronized between CentOS_Project and Rocky_Project, so that both projects have consistent and up-to-date documentation.

#### Acceptance Criteria

1. THE README.md SHALL follow the same structure as Rocky_Project README.md with CentOS-specific content
2. THE CHANGELOG.md files in each Version_Folder SHALL follow the same format as Rocky_Project CHANGELOG.md files
3. THE Documentation SHALL be written in English for technical content
4. WHEN user-facing documentation is created, THE Documentation SHALL be provided in Simplified Chinese (简体中文)

### Requirement 27: CI/CD Pipeline Alignment

**User Story:** As a developer, I want CI/CD pipelines to align with Rocky_Project patterns, so that automated testing and deployment follow the same workflows.

#### Acceptance Criteria

1. THE CI_Pipeline SHALL implement the same quality gates as Rocky_Project including linting, formatting, and security scanning
2. THE CI_Pipeline SHALL use the same GitHub Actions workflow structure as Rocky_Project
3. THE CI_Pipeline SHALL support matrix builds for all supported Architectures
4. THE CI_Pipeline SHALL enforce Conventional_Commits validation on all pull requests

### Requirement 28: Security Scanning Integration

**User Story:** As a developer, I want security scanning to be integrated into the development workflow, so that vulnerabilities are detected early.

#### Acceptance Criteria

1. THE Security_Scanner SHALL scan all Docker images for known vulnerabilities
2. THE Security_Scanner SHALL scan all dependencies for known vulnerabilities
3. THE Security_Scanner SHALL run automatically in CI/CD pipelines
4. WHEN a critical vulnerability is detected, THE CI_Pipeline SHALL fail and block merging

### Requirement 29: Multi-Architecture Build Support

**User Story:** As a developer, I want to build Docker images for multiple architectures, so that the images can run on diverse hardware platforms.

#### Acceptance Criteria

1. THE Build_System SHALL support building images for all Architectures specified in Requirement 4
2. THE Build_System SHALL use Docker Buildx or equivalent multi-architecture build tooling
3. THE Build_System SHALL produce manifest lists that reference all architecture-specific images
4. THE Build_System SHALL follow the same multi-architecture build pattern as Rocky_Project

### Requirement 30: Automated Testing Framework

**User Story:** As a developer, I want an automated testing framework to verify that aligned content functions correctly, so that regressions are caught before deployment.

#### Acceptance Criteria

1. THE Test_Framework SHALL verify that Docker images build successfully for all Architectures
2. THE Test_Framework SHALL verify that containers start successfully and execute the entrypoint script without errors
3. THE Test_Framework SHALL verify that all environment variables are correctly set in running containers
4. THE Test_Framework SHALL verify that all installed packages are present and functional
