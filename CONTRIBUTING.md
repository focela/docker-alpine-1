# Contributing to Docker Alpine

Thank you for your interest in contributing to the Docker Alpine project! We welcome contributions from developers of all skill levels and backgrounds. This project focuses on creating robust, secure, and lightweight Alpine Linux-based Docker images with s6-overlay service management.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)
- [Testing Requirements](#testing-requirements)
- [Documentation](#documentation)
- [Community](#community)
- [Getting Help](#getting-help)

---

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it to understand the standards we expect from all community members.

---

## Getting Started

### Prerequisites

Before contributing, ensure you have the following installed:

- **Git** (version 2.0 or higher)
- **Docker** (version 20.0 or higher)
- **Docker Compose** (version 2.0 or higher)
- **Alpine Linux knowledge** (basic package management, ash/bash scripting)
- **s6-overlay familiarity** (service management and lifecycle)
- **Text Editor/IDE** with Dockerfile, Bash, and Markdown syntax highlighting
- **Make** (for build automation)

### Alpine-Specific Knowledge

Familiarity with these Alpine Linux concepts will help:

- **apk package manager** and package selection
- **musl libc** vs glibc differences
- **busybox utilities** and POSIX compliance
- **s6-overlay** service definitions and lifecycle management
- **Alpine security model** and minimal attack surface principles

### Initial Setup

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/docker-alpine.git
   cd docker-alpine
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/focela/docker-alpine.git
   ```
4. **Build test images**:
   ```bash
   make build
   ```
5. **Run tests**:
   ```bash
   make test
   ```

---

## Development Workflow

### Branching Strategy

We use a **feature branch workflow**:

- `main` - Production-ready code
- `develop` - Integration branch for new features
- `feature/*` - Individual feature development
- `bugfix/*` - Bug fixes
- `hotfix/*` - Critical production fixes

### Creating a Feature Branch

```bash
# Update your local main branch
git checkout main
git pull upstream main

# Create and checkout a new feature branch
git checkout -b feature/your-feature-name

# Push the branch to your fork
git push -u origin feature/your-feature-name
```

### Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat` - New features
- `fix` - Bug fixes
- `docs` - Documentation changes
- `style` - Code style changes (formatting, etc.)
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks

**Examples:**
```bash
feat(services): add monitoring service definition
fix(alpine): resolve package dependency conflict  
feat(s6): add logging service with fluent-bit support
fix(dockerfile): optimize layer caching for faster builds
docs(services): update firewall service configuration guide
```

### Daily Development

```bash
# Keep your branch updated
git fetch upstream
git rebase upstream/main

# Make your changes and commit
git add .
git commit -m "feat(scope): description of changes"

# Push to your fork
git push origin feature/your-feature-name
```

---

## Code Standards

## Code Standards

### Dockerfile Best Practices

- **Base image**: Always use official Alpine Linux images (`alpine:latest` or specific versions)
- **Layer optimization**: Combine RUN commands to minimize layers
- **Package cleanup**: Always clean apk cache with `rm -rf /var/cache/apk/*`
- **Security**: Run as non-root user when possible
- **Size optimization**: Use multi-stage builds for complex applications
- **Labels**: Include proper OCI labels for metadata

**Example:**
```dockerfile
FROM alpine:3.19

RUN apk add --no-cache \
      bash \
      curl \
      tzdata \
    && rm -rf /var/cache/apk/*

# s6-overlay installation
ENV S6_OVERLAY_VERSION=3.1.6.2
RUN apk add --no-cache --virtual .s6-deps \
      curl \
    && curl -L "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
       | tar -C / -Jxpf - \
    && apk del .s6-deps
```

### s6-overlay Service Scripts

- **Shebang**: Use `#!/command/with-contenv bash` for environment variable access
- **Indentation**: 2 spaces (no tabs)
- **Line length**: Maximum 120 characters
- **Error handling**: Use `set -euo pipefail` where appropriate, but be cautious with s6-overlay
- **Variable naming**: Use `snake_case` for variables
- **Function naming**: Use lowercase with underscores
- **Service lifecycle**: Follow s6-overlay patterns (`prepare_service`, `liftoff`, etc.)
- **Comments**: Document service dependencies and timing requirements

**Example:**
```bash
#!/command/with-contenv bash
# Service initialization script for container monitoring

source /assets/functions/00-container
PROCESS_NAME="monitoring"
output_off
prepare_service
check_container_initialized
check_service_initialized init

liftoff

print_start "Starting ${PROCESS_NAME} service"
exec monitoring-daemon --config=/etc/monitoring/config.yml
```

### Alpine Package Management

- **Minimal packages**: Only install necessary packages
- **Virtual packages**: Use `--virtual` for build dependencies
- **Package pinning**: Pin package versions for reproducibility when needed
- **Security updates**: Regularly update base images and packages
- **Package selection**: Prefer Alpine native packages over compilation

### Shell Scripting (ash/bash)

- **Indentation**: 2 spaces (no tabs)
- **Line length**: Maximum 120 characters
- **Shebang**: Use `#!/bin/bash` or `#!/command/with-contenv bash` for s6-overlay
- **Error handling**: Always use `set -euo pipefail` where appropriate
- **Variable naming**: Use `snake_case` for variables
- **Function naming**: Use lowercase with underscores
- **Comments**: Document complex logic and business rules

**Example:**
```bash
#!/command/with-contenv bash
# Service initialization script for container monitoring

set -euo pipefail

PROCESS_NAME="monitoring"
SERVICE_PORT="${MONITORING_PORT:-8080}"

initialize_service() {
  print_debug "Initializing ${PROCESS_NAME} service on port ${SERVICE_PORT}"
  # Implementation here
}
```

### Markdown Files

- **Headings**: Use ATX-style headers (`# ## ###`)
- **Line length**: Aim for 80-100 characters for readability
- **Lists**: Use `-` for unordered lists, `1.` for ordered lists
- **Code blocks**: Always specify language for syntax highlighting
- **Links**: Use descriptive text, avoid raw URLs

### Docker & Configuration

- **Indentation**: 2 spaces for YAML, 4 spaces for Dockerfile
- **Comments**: Document non-obvious configuration choices
- **Security**: Never include secrets or sensitive data
- **Efficiency**: Use multi-stage builds and minimal base images

---

## Pull Request Process

### Before Submitting

- [ ] **Tests pass**: Run `make test` locally
- [ ] **Code quality**: Run `make lint` and fix any issues
- [ ] **Documentation**: Update relevant documentation
- [ ] **Self-review**: Review your own code for clarity and completeness
- [ ] **Rebase**: Ensure your branch is up-to-date with main

### PR Guidelines

1. **Title**: Use conventional commit format
2. **Description**: Include:
    - Summary of changes
    - Motivation and context
    - Testing instructions
    - Screenshots (if applicable)
    - Breaking changes (if any)

3. **Size**: Keep PRs focused and reasonably sized (< 500 lines when possible)
4. **Draft**: Use draft PRs for work-in-progress to get early feedback

### PR Template

```markdown
## Summary
Brief description of what this PR does.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
```

### Review Process

1. **Automated checks** must pass (CI/CD pipeline)
2. **At least one reviewer** approval required
3. **Address feedback** promptly and respectfully
4. **Squash commits** before merging (if requested)

---

## Issue Guidelines

### Before Creating an Issue

- **Search existing issues** to avoid duplicates
- **Check documentation** for answers to common questions
- **Use latest version** and verify the issue still exists

### Bug Reports

Use the bug report template and include:

- **Environment details** (OS, Docker version, etc.)
- **Steps to reproduce** the issue
- **Expected vs actual behavior**
- **Error messages** and logs
- **Minimal reproduction case** if possible

### Feature Requests

Use the feature request template and include:

- **Problem description** you're trying to solve
- **Proposed solution** with technical details
- **Alternatives considered**
- **Additional context** or examples

### Issue Labels

- `bug` - Something isn't working
- `enhancement` - New feature or improvement
- `documentation` - Documentation related
- `good-first-issue` - Good for newcomers
- `help-wanted` - Extra attention needed
- `priority-high` - Urgent issues

---

## Testing Requirements

### Running Tests

```bash
# Build and test all images
make test

# Build specific image variant
make build VARIANT=monitoring

# Test specific service
make test-service SERVICE=logging

# Run security scans
make security-scan

# Test s6-overlay services
make test-services
```

### Testing Types

- **Image builds**: Verify Dockerfiles build successfully
- **Service functionality**: Test s6-overlay service definitions
- **Package installation**: Verify Alpine packages install correctly
- **Security scanning**: Scan for vulnerabilities with tools like Trivy
- **Container runtime**: Test container startup and service orchestration
- **Resource usage**: Monitor memory and CPU usage for optimization

### Writing Tests

- **Unit tests**: Test individual functions and components
- **Integration tests**: Test service interactions
- **Shell script tests**: Use [bats](https://github.com/bats-core/bats-core) framework
- **Documentation tests**: Verify code examples work

### Test Guidelines

- **Descriptive names**: Test names should describe what they verify
- **Arrange-Act-Assert**: Follow the AAA pattern
- **Clean isolation**: Tests should not depend on each other
- **Mock external dependencies**: Use mocks for external services

---

## Documentation

### What to Document

- **New services**: Include s6-overlay service setup and configuration
- **Alpine packages**: Document new package additions and justifications
- **Image variants**: Update documentation for new image variants
- **Configuration options**: Document new environment variables and volumes
- **Breaking changes**: Provide migration guides for image updates

### Documentation Standards

- **Alpine-specific**: Include Alpine Linux version compatibility
- **Clear examples**: Provide working Docker run commands and docker-compose snippets
- **Security notes**: Document any security implications or recommendations
- **Service dependencies**: Clearly outline service startup order and dependencies

### Building Documentation Locally

```bash
# Build documentation
make docs

# Serve documentation locally
make docs-serve

# Check for broken links
make docs-check
```

---

## Community

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and community chat
- **Email**: [security@focela.com](mailto:security@focela.com) for security issues

### Getting Involved

- **New service definitions**: Create s6-overlay services for common applications
- **Image optimization**: Improve Docker layer efficiency and size reduction
- **Security hardening**: Enhance Alpine security configurations
- **Package updates**: Keep Alpine packages current and secure
- **Documentation**: Improve setup guides and service configuration examples
- **Testing**: Add comprehensive tests for new image variants
- **Performance optimization**: Improve container startup times and resource usage

### Alpine-Specific Contributions

- **Service integrations**: Add popular applications as s6-overlay services
- **Multi-architecture**: Support ARM64 and other architectures
- **Security scanning**: Implement automated vulnerability scanning
- **Package curation**: Research and add useful Alpine packages
- **Performance tuning**: Optimize for container environments

### Recognition

We appreciate all contributions! Contributors will be:

- **Acknowledged** in release notes
- **Listed** in the CONTRIBUTORS.md file
- **Invited** to join the maintainers team (for significant contributors)

---

## Getting Help

### Resources

- **Documentation**: Check the project documentation first
- **FAQ**: Common questions and answers
- **Examples**: Working examples in the `examples/` directory
- **Discussions**: Community Q&A and support

### Contact Methods

- **General Questions**: Use GitHub Discussions
- **Bug Reports**: Create a GitHub Issue
- **Security Issues**: Email [security@focela.com](mailto:security@focela.com)
- **Private Matters**: Contact maintainers directly

### Response Times

- **Issues**: We aim to respond within 48 hours
- **Pull Requests**: Initial review within 3-5 business days
- **Security Issues**: Response within 24 hours

---

## Thank You

Thank you for contributing to the Docker Alpine project! Your involvement helps create better, more secure, and more efficient Alpine Linux-based container images for the community. Together, we're building a foundation for lightweight, production-ready containerized applications.

Happy Alpine hacking! 🏔️🐳
