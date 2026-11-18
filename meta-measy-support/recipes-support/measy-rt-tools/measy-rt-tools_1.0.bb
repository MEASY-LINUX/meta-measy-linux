# Copyright (C) 2026 MYIR Tech Limited
# SPDX-License-Identifier: MIT

SUMMARY = "MYIR PREEMPT_RT runtime inspection tools"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://measy-rt-check"

S = "${UNPACKDIR}"

RDEPENDS:${PN} = "bash"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/measy-rt-check ${D}${sbindir}/measy-rt-check
}
