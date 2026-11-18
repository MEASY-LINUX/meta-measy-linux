---
name: measy-yocto-engineering
description: Create, review, migrate, and debug MEasyLinux Yocto and BitBake metadata including layers, recipes, bbappends, classes, distro and machine configuration, images, packages, SDKs, QA, fetch/patch/build failures, and root filesystem composition. Use for release-sensitive metadata work and build diagnosis.
---

# MEasy Yocto Engineering

Prefer local metadata, task logs, and the matching official Yocto/BitBake
documentation over memory. The current MEasyLinux baseline is Wrynose.

## Workflow

1. Identify the release, `MACHINE`, `DISTRO`, target, failing task, and first
   causal error. Do not start from the last summary line.
2. Prove metadata visibility with `bitbake-layers show-layers`, `show-appends`,
   `show-recipes`, or `show-overlayed` as appropriate.
3. Inspect resolved values with `bitbake -e` and task logs under
   `tmp/work/.../temp/`. Distinguish recipe names, output packages, providers,
   build dependencies, and runtime dependencies.
4. Make a minimal release-compatible change using modern override syntax.
   Declare licenses, checksums, dependencies, compatibility, and packaging
   explicitly.
5. Parse first, build the narrow target, then validate the consuming image or
   SDK. Check deploy output, package contents, and runtime behavior.

## Review Checklist

- unique layer collection and correct recipe globs
- accurate `LAYERSERIES_COMPAT` and direct `LAYERDEPENDS`
- matching `.bbappend` versions and intentional optional-layer behavior
- reproducible sources and complete license metadata
- correct `DEPENDS`, `RDEPENDS:${PN}`, `FILES:${PN}`, and service packaging
- no unexplained QA suppression, host path, secret, or broad clean operation

Do not recommend deleting `tmp`, `downloads`, or `sstate-cache` as a first fix.

## Output

Return the most likely cause, evidence, exact metadata change, why it works in
BitBake terms, validation commands, and remaining release or platform risk.
