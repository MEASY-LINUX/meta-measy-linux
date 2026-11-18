# Real-time Linux integration

Set the following in product or build configuration to enable PREEMPT_RT:

```bitbake
MEASY_RT_ENABLE = "1"
```

The default is `0`. When disabled, this layer does not alter the kernel or
image. When enabled for a qualified machine it:

- keeps the vendor `linux-imx` provider and revision;
- enables the Linux 6.18 mainline PREEMPT_RT implementation;
- applies the NXP Real-Time Edge rwbase/ENETC lock correction;
- exposes `/sys/kernel/realtime` and adds an `-rt` kernel suffix;
- installs `rt-tests`, `stress-ng`, and `measy-rt-check`.

The currently qualified metadata target is `myd-jmx95x-b0`. Enabling RT for a
different machine fails at parse time until it is added to
`MEASY_RT_SUPPORTED_MACHINES` after validation.

CPU isolation, IRQ affinity, CPU frequency governors, idle states, and thermal
policy are intentionally not changed automatically. These are product policies
and must be selected from measured board results.

## Validation

On the target, first run:

```sh
measy-rt-check
cyclictest --mlockall --smp --priority=80 --interval=1000 --distance=0 \
    --duration=10m --histogram=2000
```

Record the kernel revision, preemption model, boot arguments, CPU/IRQ policy,
load, duration, maximum latency, histogram, and overruns. Repeat under idle,
CPU/memory stress, storage/network I/O, and representative product load.

A product implementation must explicitly define:

- kernel provider, revision, and preemption model;
- timer frequency, CPU isolation, IRQ affinity, scheduler, and memory locking;
- CPU frequency, idle-state, thermal, and power-management assumptions;
- idle, I/O stress, product-load, and long-duration latency tests;
- accepted maximum latency, jitter, overruns, and recovery behavior.

Keep product policy in reviewed distro or machine configuration selected by
`measy-rt`. Do not silently disable security or reliability features to improve
benchmark results.
