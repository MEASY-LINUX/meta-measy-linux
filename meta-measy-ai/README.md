# meta-measy-ai

This layer versions MEasyLinux engineering skills beside the Yocto source that
they describe. The skills are host-side assets: `layer.conf` does not match the
`skills/` tree, so adding this layer does not install skill content into an
image or SDK.

## Skills

| Skill | Scope |
| --- | --- |
| `measy-workflow-orchestrator` | Requirement intake, task ordering, specialist routing, evidence, and workbench updates |
| `measy-bsp-porting` | Board bring-up, boot chain, kernel, device tree, drivers, and firmware |
| `measy-system-integration` | Services, networking, storage, observability, and product behavior |
| `measy-yocto-engineering` | Layers, recipes, images, packaging, QA, and BitBake diagnostics |
| `measy-qa-validation` | Immutable source snapshots, build/deploy/board tests, RT/security checks, and reports |

Each directory under `skills/` is independently installable. For Codex, link
the required skill folders into the user's Codex skill directory; do not make
the build depend on a particular agent host.

The structure is based on the self-contained skill pattern from
https://github.com/Higangssh/yocto-agent-skills. Release-sensitive Yocto facts
must still be checked against local metadata and official Yocto/BitBake
documentation.

## Integration Model

The workflow orchestrator reads the customer work item, verifies required
inputs, orders tasks, invokes the relevant specialist skill, and writes each
stage result back to the same work item. QA consumes an immutable source,
configuration, and skill-version snapshot and records its result independently
from customer functional acceptance.

The local `docs/AI_QA_ARCHITECTURE.md`, when available, covers component
boundaries, lifecycle, state separation, and the proposed runtime interfaces.
