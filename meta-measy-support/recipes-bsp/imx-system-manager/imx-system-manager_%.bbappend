# Copyright (C) 2026 MYIR Tech Limited
# SPDX-License-Identifier: MIT

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

MEASY_RT_SYSTEM_MANAGER_FILES = " \
    file://0001-imx95-disable-ddr-auto-clock-gating-for-rt.patch \
"

SRC_URI:append = "${@' ' + d.getVar('MEASY_RT_SYSTEM_MANAGER_FILES') if d.getVar('MEASY_RT_ENABLED') == '1' else ''}"
