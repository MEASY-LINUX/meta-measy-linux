FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:myir-jmx95 = "${@' file://myir-ota-slot.sh file://myir-ota-slot.service' if d.getVar('OTA_SUPPORT') == '1' else ''}"

SYSTEMD_SERVICE:${PN}:myir-jmx95 = "${@'myir-swupdate.service' if d.getVar('OTA_SUPPORT') == '1' else ''}"
RDEPENDS:${PN}:append:myir-jmx95 = "${@' libubootenv-bin util-linux-findmnt' if d.getVar('OTA_SUPPORT') == '1' else ''}"

do_install:append:myir-jmx95() {
    if [ "${OTA_SUPPORT}" = "1" ]; then
        install -m 0755 ${UNPACKDIR}/myir-ota-slot.sh \
            ${D}${sysconfdir}/myir-swupdate.sh
        install -m 0644 ${UNPACKDIR}/myir-ota-slot.service \
            ${D}${systemd_system_unitdir}/myir-swupdate.service
    else
        rm -f ${D}${sysconfdir}/myir-swupdate.sh \
            ${D}${systemd_system_unitdir}/myir-swupdate.service
        (cd ${D} && rmdir -p --ignore-fail-on-non-empty .${systemd_system_unitdir})
    fi
}
