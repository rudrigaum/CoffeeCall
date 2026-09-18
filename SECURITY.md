# Security Policy

Security is an important part of Coffee Call's development process.

This document describes how security issues should be reported and the baseline security practices expected in the project.

## Supported Versions

Coffee Call is currently under active development and has not yet reached its first production release.

Security fixes are applied to the latest version of the `main` branch.

| Version | Supported |
|---|---|
| `main` | ✅ |
| Previous development snapshots | ❌ |

This policy may evolve once versioned releases are introduced.

## Reporting a Vulnerability

Please do not publicly disclose security vulnerabilities through GitHub Issues.

If you discover a potential vulnerability, report it privately to the repository owner or through GitHub's private vulnerability reporting feature when available.

A useful report should include:

- A clear description of the issue
- Steps to reproduce the vulnerability
- Potential impact
- Affected component or feature
- Relevant logs or screenshots with sensitive information removed
- Suggested remediation, if known

Avoid including credentials, authentication tokens, personal data, or other secrets in reports.

## Security Principles

Coffee Call follows these baseline security principles:

- Never commit credentials or secrets to source control
- Never log passwords, tokens, or sensitive customer information
- Use HTTPS for all remote communication
- Store authentication tokens and sensitive credentials in Keychain
- Do not store secrets in `UserDefaults`
- Keep dependencies and development tooling updated
- Validate and sanitize external input when applicable
- Restrict access to sensitive information to the components that require it
- Prefer secure Apple APIs and platform capabilities whenever appropriate

## Secrets

Secrets must never be hardcoded directly into the application source code.

Examples include:

```text
API tokens
Passwords
Private keys
Client secrets
Authentication credentials
```

Environment-specific configuration should be kept outside version-controlled source code.

When CI/CD is introduced, sensitive values must use the secret management mechanism provided by the CI platform.

## Authentication Data

When authentication is introduced, sensitive credentials and tokens must use secure storage.

Preferred storage:

```text
Keychain
```

Do not use:

```text
UserDefaults
.plist files committed to the repository
Hardcoded Swift constants
Plain-text local files
```

## Logging

Logs must never expose sensitive information.

Do not log:

```text
Passwords
Authentication tokens
API secrets
Personal information
Payment information
```

Debug logging must be reviewed before production releases.

## Networking

Remote communication must use HTTPS.

Networking code should validate HTTP responses and propagate meaningful errors without exposing sensitive server details to the UI.

Exceptions to platform transport security policies should not be added without a documented technical requirement.

## Dependencies

Third-party dependencies should only be introduced when they provide clear value.

Before introducing a dependency, evaluate:

- Maintenance status
- Security history
- Release activity
- Transitive dependencies
- Required permissions
- Impact on application size and attack surface

Prefer native Apple frameworks when they adequately solve the problem.

## Sensitive Files

The following types of files must never be committed when they contain sensitive information:

```text
.env
Secrets.swift
APIKeys.swift
*.p12
*.mobileprovision
private keys
service credentials
```

The repository `.gitignore` should be updated whenever new sensitive local configuration files are introduced.

## Security Review

Security-sensitive changes should receive additional review.

Examples include:

- Authentication
- Authorization
- Keychain access
- Networking
- User data persistence
- Payment flows
- API credential handling
- Deep links
- Web content
- File access

Tests should be added whenever security-sensitive behavior can be validated automatically.

## Incident Response

If a confirmed vulnerability affects released software:

1. Assess the impact
2. Avoid public disclosure until mitigation is available
3. Implement and review the fix
4. Add regression tests when applicable
5. Release the corrected version
6. Document the issue appropriately after users are protected

## Responsible Disclosure

Responsible disclosure helps protect users while allowing maintainers sufficient time to investigate and resolve security issues.

Security reports submitted in good faith are appreciated.
