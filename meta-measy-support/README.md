# meta-measy-support

`meta-measy-support` contains reusable platform-support capabilities above the
vendor BSP. The initial scope is AMP integration, real-time Linux, and kernel
crash capture.

## Planned Capabilities

| Capability | Proposed feature | Content |
| --- | --- | --- |
| AMP | `measy-amp` | OpenAMP/RPMsg userspace, remoteproc policy, firmware deployment, diagnostics, and board validation |
| Real-time | `measy-rt` | PREEMPT_RT or selected RT kernel, IRQ/scheduler/CPU policy, runtime tools, and latency qualification |
| Kernel crash | `measy-kcrash` | kexec/kdump, crash kernel, reserved memory contract, dump persistence, retention, export, and recovery |

The real-time capability is implemented and remains disabled by default. Set
`MEASY_RT_ENABLE = "1"` in product or build configuration to select it. Adding
this layer alone changes no image content and no machine configuration.

The local `docs/real-time.md`, when available, describes the implementation
and its relationship to NXP Real-Time Edge.

## Ownership

- The vendor BSP owns SoC drivers, device trees, remoteproc devices, reserved
  memory, and platform firmware interfaces.
- This layer owns reusable integration recipes, configuration fragments,
  services, tools, and validation helpers.
- Product distro or machine configuration explicitly enables a capability.

Never choose firmware addresses, reserve crash memory, or enable a feature
globally in `layer.conf`. Do not replace the product kernel provider merely by
adding this layer. Each supported machine needs build and board evidence.

For RT, record the selected preemption model and kernel revision, CPU frequency
and idle-state policy, IRQ affinity, isolated CPUs, scheduler policy, test load,
test duration, maximum latency, and overruns. Measure idle and representative
product load with tools such as `cyclictest`; a successful build is not an RT
acceptance result.
