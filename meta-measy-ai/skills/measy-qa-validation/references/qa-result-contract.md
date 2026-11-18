# QA Result Contract

## Run Identity

Record project/task/run IDs, exact source commits, configuration and skill
versions, Yocto release, `MACHINE`, `DISTRO`, target, build profile, board and
revision, executor, fixtures, test catalog, and start/end time.

## Evidence Per Stage

| Stage | Required evidence |
| --- | --- |
| Review | compared commits, findings, risks, continue/block decision |
| Build | registered entry point, environment identity, exit code, full log, artifact path and hash |
| Deploy | board reservation, deployment method, serial/power record, running artifact identity |
| Test | test ID/version, prerequisites, command/tool, raw output, measurements, criterion, result |
| Security | image-derived SBOM, scanner/database version and time, findings, evidence gaps |
| Report | immutable links to all evidence, summary, limitations, next action |

Use only `passed`, `failed`, `skipped`, `unverified`, and `waiting` for observed
test results. `skipped` requires an approved applicability reason. `unverified`
means no valid conclusion was produced. `waiting` names a concrete missing
condition. Additional diagnostics append to the original observation.

For RT tests, also record kernel revision/provider, preemption model, CPU and
IRQ policy, frequency/idle/thermal policy, test load and duration, sample count,
maximum latency, jitter/percentiles where available, and overruns.
