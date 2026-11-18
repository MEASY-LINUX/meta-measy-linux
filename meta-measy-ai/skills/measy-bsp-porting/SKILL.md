---
name: measy-bsp-porting
description: Plan, implement, review, and validate MEasyLinux board support changes involving bootloaders, kernels, device trees, drivers, firmware, pinmux, clocks, regulators, storage, or board interfaces. Use for new-board bring-up, vendor SDK migration, BSP regression, and customer hardware customization.
---

# MEasy BSP Porting

Ground every change in the target SoC, board revision, Yocto release, vendor SDK
baseline, and reproducible hardware evidence.

## Workflow

1. Record the source and target baselines: manifests, commits, machine,
   distribution, kernel provider, bootloader provider, and board revision.
2. Inventory boot media, memory, power, clocks, pinmux, buses, peripherals,
   firmware, and security state. Mark unknowns instead of guessing values.
3. Locate ownership before editing: keep machine facts in the BSP and product
   policy in the relevant MEasy layer.
4. Make the smallest reviewable change. Preserve vendor changes and explain
   every new patch, config fragment, device-tree node, and provider selection.
5. Build the narrowest affected target, then the product image. Inspect actual
   deploy artifacts and resolved metadata rather than relying on source text.
6. Validate cold boot, warm reboot, recovery, required interfaces, and negative
   cases on the named board. Record commands, logs, measurements, and failures.
7. Document rollback and update the affected skill/version mapping.

## Required Evidence

- `MACHINE`, `DISTRO`, release name, manifests, and relevant revisions
- resolved providers and applied appends
- build task result and deploy artifact hashes
- serial boot log and board test results
- known limitations, recovery steps, and rollback point

Do not claim board support from compilation alone. Do not perform irreversible
fuse, secure-close, or production provisioning actions.

## Output

Return the baseline, ownership decision, changed files, exact validation steps,
observed results, remaining risks, and rollback procedure.
