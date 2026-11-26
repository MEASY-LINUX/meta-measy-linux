# Keep removable-media automounting available, but prevent an OTA target from
# mounting the eMMC A/B system partitions behind SWUpdate's back.
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = "${@' file://0001-mount-ignore-emmc-ota-system-partitions.patch' if d.getVar('OTA_SUPPORT') == '1' else ''}"
