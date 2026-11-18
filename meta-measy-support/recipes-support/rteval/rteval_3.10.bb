# Copyright (C) 2026 MYIR Tech Limited
# SPDX-License-Identifier: MIT

SUMMARY = "Real-time performance evaluation"
HOMEPAGE = "https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/rteval"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "https://git.kernel.org/pub/scm/utils/rteval/rteval.git/snapshot/rteval-${PV}.tar.gz \
           file://rteval.conf \
           file://0001-rteval-Tailored-for-NXP-boards-and-Yocto-rootfs.patch \
"
SRC_URI[sha256sum] = "6f11a1487bab4abb52088c06449d960d0dc9bfbd014481c0f98c40a0f1751cf4"

S = "${UNPACKDIR}/rteval-${PV}"

inherit python_setuptools_build_meta

do_compile:append() {
    ${PYTHON} -m py_compile ${S}/rteval-cmd
}

do_install:append() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${UNPACKDIR}/rteval.conf ${D}${sysconfdir}/rteval.conf
}

RDEPENDS:${PN} += " \
    rt-tests \
    stress-ng \
    python3-core \
    python3-lxml \
    libxml2 \
"
