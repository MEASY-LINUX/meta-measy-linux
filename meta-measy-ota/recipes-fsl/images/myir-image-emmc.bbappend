# MYD-JMX95X A/B OTA integration.  The layer may stay enabled in BBLAYERS;
# OTA_SUPPORT is the only product-level switch.
FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

def myir_ota_boot_files(d):
    import os

    if d.getVar('MYIR_FITIMAGE_BOOT') == '1':
        files = ['fitImage']
    elif d.getVar('MYIR_AHAB_ENABLE') == '1':
        files = (d.getVar('SECURE_BOOT_FILES') or '').split()
    else:
        files = [(d.getVar('KERNEL_IMAGETYPE') or 'Image')]

    files.extend(os.path.basename(path) for path in
                 (d.getVar('KERNEL_DEVICETREE') or '').split())
    return ' '.join(dict.fromkeys(files))

def myir_ota_swdescription_files(d, workdir, slot):
    devices = {
        'slotA': '/dev/mmcblk0p1',
        'slotB': '/dev/mmcblk0p3',
    }
    device = devices.get(slot)
    if not device:
        bb.fatal('Unknown MYD-JMX95X OTA slot %s' % slot)

    entries = []
    for filename in (d.getVar('MYIR_OTA_BOOT_FILES') or '').split():
        digest = swupdate_get_sha256(d, workdir, filename)
        entries.append(
            '{ filename = "%s"; path = "/%s"; '
            'device = "%s"; filesystem = "vfat"; '
            'sha256 = "%s"; }' %
            (filename, filename, device, digest))
    return ',\n                    '.join(entries)

python () {
    enabled = d.getVar('OTA_SUPPORT')
    if enabled not in ('0', '1'):
        bb.fatal('OTA_SUPPORT must be "0" or "1", got %r' % enabled)
    overrides = (d.getVar('OVERRIDES') or '').split(':')
    if enabled == '1' and 'myir-jmx95' not in overrides:
        bb.fatal('meta-measy-ota supports only the MYD-JMX95X machine family')
}

MYIR_OTA_PACKAGES = " \
    lua \
    swupdate \
    swupdate-www \
    swupdate-progress \
    swupdate-client \
    swupdate-tools-ipc \
    systemd-swusys \
    json-c \
"

# Override the broad mx9 default in myir-image-multimedia.  Non-OTA images do
# not contain the updater even when meta-swupdate and this layer are present.
SWUPDATE:myir-jmx95:mx9-nxp-bsp = "${@d.getVar('MYIR_OTA_PACKAGES') if d.getVar('OTA_SUPPORT') == '1' else ''}"

IMAGE_CLASSES:append:myir-jmx95 = "${@' swupdate-image' if d.getVar('OTA_SUPPORT') == '1' else ''}"

SWUPDATE_VERSION:myir-jmx95 = "${DISTRO_VERSION}${IMAGE_VERSION_SUFFIX}"
MYIR_OTA_ROOTFS_FSTYPE = "${@'.ext4.verity' if d.getVar('ENABLE_DM_VERITY') == '1' else '.ext4'}"
MYIR_OTA_ROOTFS_FILE = "${IMAGE_BASENAME}-${MACHINE}.rootfs${MYIR_OTA_ROOTFS_FSTYPE}"
SWUPDATE_IMAGES_FSTYPES[myir-image-emmc] = "${MYIR_OTA_ROOTFS_FSTYPE}"

MYIR_OTA_BOOT_FILES = "${@myir_ota_boot_files(d)}"
SWUPDATE_IMAGES:append:myir-jmx95 = "${@' ' + d.getVar('MYIR_OTA_BOOT_FILES') if d.getVar('OTA_SUPPORT') == '1' else ''}"

SWUPDATE_SIGNING:myir-jmx95 = "${@'RSA' if d.getVar('OTA_SUPPORT') == '1' else ''}"

do_rootfs[depends] += "${@'swupdate-signing-keys:do_deploy' if d.getVar('OTA_SUPPORT') == '1' else ''}"
do_swuimage[depends] += "${@'swupdate-signing-keys:do_deploy' if d.getVar('OTA_SUPPORT') == '1' else ''}"

install_swupdate_public_key() {
    if [ "${OTA_SUPPORT}" != "1" ]; then
        return
    fi
    if [ ! -s "${SWUPDATE_PUBLIC_KEY}" ]; then
        bbfatal "SWUpdate public key not found: ${SWUPDATE_PUBLIC_KEY}"
    fi
    install -d ${IMAGE_ROOTFS}${sysconfdir}
    install -m 0644 ${SWUPDATE_PUBLIC_KEY} \
        ${IMAGE_ROOTFS}${sysconfdir}/swu_public.pem
    touch ${IMAGE_ROOTFS}${sysconfdir}/myir-ota-enabled
}

ROOTFS_POSTPROCESS_COMMAND:append:myir-jmx95 = " install_swupdate_public_key;"

# The product WIC remains the existing single-slot normal/AHAB/dm-verity
# image.  Factory provisioning creates p1-p4 (and p5 for dm-verity), avoiding
# a raw WIC containing two complete root filesystems.
