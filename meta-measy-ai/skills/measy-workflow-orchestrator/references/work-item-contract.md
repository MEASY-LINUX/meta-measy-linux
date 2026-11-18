# Work Item Contract

Use this logical contract for a workbench, Markdown record, JSON payload, or QA
service. Preserve stable identifiers and append run records.

## Requirement

- `project_id`, `requirement_id`, title, owner, priority
- capability class: `bsp`, `system`, `yocto`, or cross-cutting
- goal and measurable acceptance criteria
- board model/revision, interface or component designator, optional schematic
  page, required external equipment, and requested customer actions
- functional state and QA state as separate fields

## Versioned Execution Input

- repository URL/path, role, branch, and exact commit for every source
- manifest/configuration version, Yocto release, `MACHINE`, `DISTRO`, target
- build profile: `normal`, `rt`, `security`, or an explicitly defined profile
- environment/executor identity and approved build entry point
- skill names and versions, test catalog version, retry reason

## Append-Only Run

- `task_id`, `run_id`, parent/retry run, timestamps, actor/executor
- ordered commands or tool calls, exit codes, full log/artifact references
- built and deployed artifact hashes plus device-reported identity
- observed result: `passed`, `failed`, `skipped`, `unverified`, or `waiting`
- extracted evidence, risks, missing inputs, rollback, and next permitted action

Functional progression is `ready`, `in-progress`, `function-verified`,
`awaiting-customer-acceptance`, then `accepted`. QA progression is independent:
`not-scheduled`, `queued`, `running`, then a recorded result. Never infer one
state from the other.
