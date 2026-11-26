# A/B is enabled only by the OTA product switch.  Secure boot alone keeps the
# factory target single-slot.
MYIR_FACTORY_TARGET_OTA ?= "${OTA_SUPPORT}"
MYIR_FACTORY_LAYOUT = "${@'ab' if d.getVar('MYIR_FACTORY_TARGET_OTA') == '1' else 'single'}"
MYIR_FACTORY_POPULATE_INACTIVE_SLOT = "${@'0' if d.getVar('MYIR_FACTORY_TARGET_OTA') == '1' else '1'}"
MYIR_FACTORY_OVERLAY_SIZE_MIB = "${@'4096' if d.getVar('MYIR_FACTORY_TARGET_OTA') == '1' else (d.getVar('MYIR_OVERLAY_PARTITION_SIZE') or '2048')}"
