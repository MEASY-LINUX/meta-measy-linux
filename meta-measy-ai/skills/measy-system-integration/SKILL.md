---
name: measy-system-integration
description: Design, implement, review, and validate MEasyLinux product integration for systemd services, networking, storage, logging, observability, startup, recovery, configuration, and application deployment. Use when turning BSP capabilities into repeatable product behavior or diagnosing cross-service system failures.
---

# MEasy System Integration

Treat system integration as an observable lifecycle, not merely a package list.

## Workflow

1. Define the user-visible behavior, supported machines, startup dependencies,
   persistent state, security boundary, failure modes, and recovery target.
2. Identify which layer owns the policy and which upstream or BSP components
   provide the mechanism.
3. Map runtime dependencies, users/groups, permissions, configuration, service
   ordering, writable paths, logs, watchdog behavior, and upgrade impact.
4. Implement configuration and services with deterministic defaults. Keep
   credentials and machine-specific secrets outside recipes.
5. Verify package contents, resolved runtime dependencies, enabled units, boot
   ordering, persistent state, resource use, and failure/restart behavior.
6. Test first boot, normal boot, restart, power loss, storage-full behavior, and
   rollback or factory recovery where applicable.

## Guardrails

- Do not hide ordering defects with arbitrary sleeps.
- Do not write persistent data into read-only or update-managed partitions.
- Do not enable a global distro feature merely because a layer is present.
- Preserve an explicit migration path for configuration and persistent data.

## Output

Return a dependency and ownership summary, configuration changes, service
lifecycle, validation matrix, observed evidence, rollback path, and unresolved
product decisions.
