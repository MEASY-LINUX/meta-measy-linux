# Copyright (C) 2026 MYIR Tech Limited
# SPDX-License-Identifier: MIT

SUMMARY = "MYIR PREEMPT_RT runtime and qualification tools"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS:${PN} = " \
    measy-rt-tools \
    rteval \
    rt-tests \
    stress-ng \
"
