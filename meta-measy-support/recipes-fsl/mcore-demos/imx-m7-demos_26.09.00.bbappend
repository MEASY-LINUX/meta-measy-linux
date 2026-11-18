# Build the MYD-JMX95X 15x15 M7 firmware from a manifest-frozen MCUX SDK
# workspace stored in one Git repository. do_fetch accesses the source
# repository and do_unpack checks out the cached commit.
MCUXSDK_SRC ?= "git://github.com/MEASY-LINUX/myir-mcuxsdk.git;protocol=https"
MCUXSDK_SRCBRANCH ?= "myd-jmx95-v26.09.00"
SRCREV:measy-amp = "20330cdd32fa25390042507e826a78093a41cc55"

SRC_URI:measy-amp = "${MCUXSDK_SRC};branch=${MCUXSDK_SRCBRANCH}"

LICENSE:measy-amp = "Proprietary & BSD-3-Clause"
LIC_FILES_CHKSUM:measy-amp = "file://mcuxsdk/COPYING-BSD-3;md5=44c38a502d2cf694b754eea743b6ec97"

# Override the vendor archive path with OE-Core's default Git checkout path.
S:measy-amp = "${UNPACKDIR}/${BP}"
B:measy-amp = "${WORKDIR}/mcuxsdk-build"

# The vendor recipe inherits fsl-eula2-unpack2, whose do_unpack additionally
# executes NXP self-extracting .bin installers. This source is a regular Git
# checkout, so use BitBake's standard unpack implementation.
python do_unpack:measy-amp() {
    bb.build.exec_func("base_do_unpack", d)
}

DEPENDS:append:measy-amp = " \
    cmake-native \
    ninja-native \
    gcc-arm-none-eabi-native \
    python3-native \
"

MCUXSDK_BOARD = "${MCUXSDK_M7_BOARD}"
MCUXSDK_ROOT = "${S}/mcuxsdk"
MCUXSDK_FIRMWARE_PREFIX = "${MCUXSDK_M7_FIRMWARE_PREFIX}"
MCUXSDK_PREFIX_MAP = " \
    -ffile-prefix-map=${WORKDIR}=/usr/src/debug/${PN}/${PV} \
    -fdebug-prefix-map=${WORKDIR}=/usr/src/debug/${PN}/${PV} \
    -fmacro-prefix-map=${WORKDIR}=/usr/src/debug/${PN}/${PV} \
"

do_configure:measy-amp() {
    :
}

do_compile:measy-amp() {
    export ARMGCC_DIR="${RECIPE_SYSROOT_NATIVE}${prefix}"

    for entry in \
        "hello_world:examples/demo_apps/hello_world" \
        "power_mode_switch:examples/demo_apps/power_mode_switch_imx95" \
        "rpmsg_pingpong:examples/multicore_examples/rpmsg_lite_pingpong_rtos_linux/remote" \
        "rpmsg_str_echo:examples/multicore_examples/rpmsg_lite_str_echo_rtos/remote" \
        "sai_low_power_audio:examples/demo_apps/sai_low_power_audio_imx95"
    do
        build_name="${entry%%:*}"
        source_path="${entry#*:}"
        build_dir="${B}/${build_name}"

        cmake \
            -S "${MCUXSDK_ROOT}/${source_path}" \
            -B "${build_dir}" \
            -G Ninja \
            -Dboard="${MCUXSDK_BOARD}" \
            -Dcore_id=cm7 \
            -DENABLE_ALL_DRIVERS=False \
            -DSdkRootDirPath="${MCUXSDK_ROOT}" \
            -DHINT=False \
            -DWEST=TRUE \
            -DCONFIG_TOOLCHAIN=armgcc \
            -DEXTRA_CFLAGS="${MCUXSDK_PREFIX_MAP}" \
            -DEXTRA_CXXFLAGS="${MCUXSDK_PREFIX_MAP}" \
            -DEXTRA_AFLAGS="${MCUXSDK_PREFIX_MAP}" \
            -DCMAKE_BUILD_TYPE=debug
        cmake --build "${build_dir}" --verbose
    done
}
MCUXSDK_COMPILE_CLEANDIRS = ""
MCUXSDK_COMPILE_CLEANDIRS:measy-amp = "${B}"
do_compile[cleandirs] += "${MCUXSDK_COMPILE_CLEANDIRS}"

do_install:measy-amp() {
    install -d "${D}${nonarch_base_libdir}/firmware"

    install -m 0644 "${B}/hello_world/hello_world_cm7.bin" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_hello_world.bin"
    install -m 0644 "${B}/hello_world/hello_world_cm7.elf" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_hello_world.elf"

    install -m 0644 "${B}/power_mode_switch/power_mode_switch_rtos_imx95_cm7.bin" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_power_mode_switch.bin"
    install -m 0644 "${B}/power_mode_switch/power_mode_switch_rtos_imx95_cm7.elf" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_power_mode_switch.elf"

    install -m 0644 "${B}/rpmsg_pingpong/rpmsg_lite_pingpong_rtos_linux_remote_cm7.bin" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_rpmsg_lite_pingpong_rtos_linux_remote.bin"
    install -m 0644 "${B}/rpmsg_pingpong/rpmsg_lite_pingpong_rtos_linux_remote_cm7.elf" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_rpmsg_lite_pingpong_rtos_linux_remote.elf"

    install -m 0644 "${B}/rpmsg_str_echo/rpmsg_lite_str_echo_rtos_remote_cm7.bin" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_rpmsg_lite_str_echo_rtos.bin"
    install -m 0644 "${B}/rpmsg_str_echo/rpmsg_lite_str_echo_rtos_remote_cm7.elf" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_rpmsg_lite_str_echo_rtos.elf"

    install -m 0644 "${B}/sai_low_power_audio/sai_low_power_audio_rtos_imx95_cm7.bin" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_sai_low_power_audio.bin"
    install -m 0644 "${B}/sai_low_power_audio/sai_low_power_audio_rtos_imx95_cm7.elf" \
        "${D}${nonarch_base_libdir}/firmware/${MCUXSDK_FIRMWARE_PREFIX}_sai_low_power_audio.elf"
}

do_deploy:measy-amp() {
    install -d "${DEPLOYDIR}/mcore-demos"
    install -m 0644 "${D}${nonarch_base_libdir}/firmware/"*.bin \
        "${D}${nonarch_base_libdir}/firmware/"*.elf \
        "${DEPLOYDIR}/mcore-demos/"
}

FILES:${PN}:measy-amp = "${nonarch_base_libdir}/firmware"
