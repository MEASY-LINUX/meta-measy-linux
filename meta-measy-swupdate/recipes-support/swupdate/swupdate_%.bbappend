FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

FILES:${PN} += "/www/*"

SRC_URI += " \
    file://swupdate-sysrestart.service \
    file://0001-mongoose-enable-cgi.patch \
    file://sysinfo.cgi \
"

FILES:${PN} += " \
    ${systemd_system_unitdir}/swupdate-sysrestart.service \
"

RDEPENDS:${PN}-www += "bash"

SYSTEMD_SERVICE:${PN} += "swupdate-sysrestart.service"

do_install:append() {
    install -m 644 ${UNPACKDIR}/swupdate-sysrestart.service ${D}${systemd_system_unitdir}/swupdate-sysrestart.service
    install -m 0755 ${UNPACKDIR}/sysinfo.cgi ${D}/www/sysinfo.cgi
}
