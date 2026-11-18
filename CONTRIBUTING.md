# Contributing to meta-measy-linux

## Layer Rules

1. Keep each `meta-measy-*` directory independently addable to `BBLAYERS`.
2. Use a unique, stable `BBFILE_COLLECTIONS` name and declare direct
   `LAYERDEPENDS` only.
3. Declare `LAYERSERIES_COMPAT` only for releases that have been parsed and
   tested. The current baseline is `wrynose`.
4. Put recipes below `recipes-<category>/<component>/`; use `%` in a
   `.bbappend` only when the append is intentionally version-independent.
5. Prefer modern override syntax such as `VAR:append` and `RDEPENDS:${PN}`.
6. Do not use layer priority to conceal provider or version-selection errors.
7. Keep optional integrations optional. Use `BBFILES_DYNAMIC` or a dedicated
   backend layer when an append targets a layer that may be absent.
8. Do not store private keys, signing credentials, customer data, internal
   build logs, absolute workstation paths, or generated build output.

## Capability Rules

- Select product capabilities through reviewed distro or machine features.
- Do not append a feature globally from `layer.conf` merely because the layer
  is present.
- Put shared policy in `conf/distro/include/`; keep board facts in the BSP.
- RAUC and SWUpdate are alternative OTA backends. A product configuration must
  select exactly one backend unless a documented migration image requires both.
- AMP describes the inter-processor framework; firmware, resource tables,
  remoteproc configuration, and validation remain machine-specific.
- Real-time support must declare the preemption model, kernel provider,
  scheduling/IRQ policy, CPU isolation, power-management assumptions, and a
  reproducible latency workload. Do not claim real-time behavior from kernel
  configuration alone.
- Kernel crash support must define reserved memory, capture kernel, storage,
  retention, export, and recovery behavior as one tested workflow.

## Skills

Each installable skill lives in its own directory and contains `SKILL.md` with
only `name` and `description` in YAML frontmatter. Keep the body procedural and
concise. Add `references/`, `scripts/`, or `assets/` only when the skill uses
them, and keep every linked resource local to that skill.

## Validation

Run the checks that match the change:

```bash
bitbake-layers show-layers
bitbake-layers show-appends
bitbake-layers show-overlayed
bitbake -p
yocto-check-layer <path-to-layer>
```

For a recipe or image change, also build the affected target and record the
deployed artifact or board test. For a skill change, run `quick_validate.py`
from the skill-creator tooling and exercise at least one representative prompt.
