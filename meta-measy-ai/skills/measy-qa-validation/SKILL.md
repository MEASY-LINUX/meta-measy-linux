---
name: measy-qa-validation
description: Plan, execute, diagnose, and report traceable MEasyLinux QA for an exact source and configuration snapshot, including code review, Yocto builds, deployment identity, board-matched functional tests, real-time latency, SBOM and vulnerability checks, evidence gaps, and release regression. Use for local SDK validation or a QA service worker; do not use QA success as customer acceptance.
---

# MEasy QA Validation

Use fixed test entry points and preserved evidence. Read
[references/qa-result-contract.md](references/qa-result-contract.md) before
recording a run.

## Pipeline

1. Freeze the repository commits, configuration version, skill versions, build
   profile, board, test catalog, executor, and fixture identities.
2. Review the delta and record risks. Stop with a blocking report when required
   inputs, authorization, or continue conditions are absent.
3. Run the registered reproducible build entry point. Preserve steps, times,
   exit codes, full logs, and output artifact hashes.
4. Deploy through the approved board/lab path and verify the running artifact's
   identity matches the frozen snapshot before testing.
5. Match required tests from board capabilities and build profile. Read each
   test's environment requirements, fixed entry point, method, and criteria.
6. Run tests and retain raw output. Mark missing hardware, wiring, credentials,
   or fixtures as `waiting` or `unverified`, never `passed`.
7. For RT profiles, record kernel/preemption identity and latency under idle,
   product load, I/O stress, thermal, and long-duration conditions.
8. For security profiles, generate the SBOM from the actual image, record the
   vulnerability database version/time, and separate evidence from compliance
   interpretation.
9. Produce a report that binds every conclusion to versions and evidence.
   Append diagnostics without overwriting the initial result.

## Program and Agent Boundary

The program owns scheduling, permissions, secrets, resource locks, state,
retention, commands, exit codes, logs, and artifacts. The agent reviews changes,
selects applicable skill rules, analyzes failures, and explains conclusions by
citing evidence. In the initial QA workflow, do not modify SDK source.

## Output

Return snapshot identity, review findings, build/deploy identity, per-test
result and evidence, missing conditions, RT/security details when applicable,
overall QA state, diagnostic notes, and next action. Keep customer acceptance
outside the QA conclusion.
