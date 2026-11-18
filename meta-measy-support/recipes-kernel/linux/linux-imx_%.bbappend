# Copyright (C) 2026 MYIR Tech Limited
# SPDX-License-Identifier: MIT

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

MEASY_RT_KERNEL_FILES = " \
    file://measy-preempt-rt.cfg \
    file://0001-preempt-rt-allow-readers-before-writer-lock.patch \
    file://0002-kernel-expose-preempt-rt-status.patch \
"

SRC_URI:append = "${@' ' + d.getVar('MEASY_RT_KERNEL_FILES') if d.getVar('MEASY_RT_ENABLED') == '1' else ''}"
LOCALVERSION:append = "${@'-rt' if d.getVar('MEASY_RT_ENABLED') == '1' else ''}"

python __anonymous () {
    if d.getVar('MEASY_RT_ENABLED') != '1':
        return

    machine = d.getVar('MACHINE')
    supported = (d.getVar('MEASY_RT_SUPPORTED_MACHINES') or '').split()
    if machine not in supported:
        bb.fatal("MEASY_RT_ENABLE is enabled for unsupported MACHINE '%s'. "
                 "Qualified machines: %s" % (machine, ' '.join(supported)))
}
