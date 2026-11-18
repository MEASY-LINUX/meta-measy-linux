# Copyright (C) 2026 MYIR Tech Limited
# SPDX-License-Identifier: MIT

# Public switch. Keep disabled by default so adding this layer is inert.
MEASY_RT_ENABLE ??= "0"

# Machines are added only after build and board-level latency qualification.
MEASY_RT_SUPPORTED_MACHINES ??= "myd-jmx95x-b0"
MEASY_RT_IMAGE_INSTALL ??= "packagegroup-measy-rt"

MEASY_RT_ENABLED = "${@'1' if bb.utils.to_boolean(d.getVar('MEASY_RT_ENABLE'), False) else '0'}"

DISTRO_FEATURES:append = "${@' measy-rt' if d.getVar('MEASY_RT_ENABLED') == '1' else ''}"
CORE_IMAGE_EXTRA_INSTALL:append = "${@' ' + d.getVar('MEASY_RT_IMAGE_INSTALL') if d.getVar('MEASY_RT_ENABLED') == '1' else ''}"
