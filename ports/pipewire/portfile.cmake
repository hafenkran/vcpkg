vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pipewire/pipewire
    REF 0.3.52
    SHA512 30e9cf74c92babafe386f02a03bb5c41a8ee5591a02f15845cca1ee44f091ce68eb14d48943d43b680cb525026a19e0290997670f9a82156eaa72e974fe6d01a
    HEAD_REF master # branch name
)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dalsa=disabled
        -Daudioconvert=disabled
        -Daudiomixer=disabled
        -Daudiotestsrc=disabled
        -Davahi=disabled
        -Dbluez5-backend-hfp-native=disabled
        -Dbluez5-backend-hsp-native=disabled
        -Dbluez5-backend-hsphfpd=disabled
        -Dbluez5-backend-ofono=disabled
        -Dbluez5-codec-aac=disabled
        -Dbluez5-codec-aptx=disabled
        -Dbluez5-codec-lc3plus=disabled
        -Dbluez5-codec-ldac=disabled
        -Dbluez5=disabled
        -Dcontrol=disabled
        -Ddbus=disabled
        -Ddocs=disabled
        -Decho-cancel-webrtc=disabled
        -Devl=disabled
        -Dexamples=disabled
        -Dffmpeg=disabled
        -Dgstreamer-device-provider=disabled
        -Dgstreamer=disabled
        -Dinstalled_tests=disabled
        -Djack-devel=false
        -Djack=disabled
        -Dlegacy-rtkit=false
        -Dlibcamera=disabled
        -Dlibcanberra=disabled
        -Dlibpulse=disabled
        -Dlibusb=disabled
        -Dlv2=disabled
        -Dman=disabled
        -Dpipewire-alsa=disabled
        -Dpipewire-jack=disabled
        -Dpipewire-v4l2=disabled
        -Dpw-cat=disabled
        -Draop=disabled
        -Droc=disabled
        -Dsdl2=disabled
        -Dsndfile=disabled
        -Dspa-plugins=enabled # This one must be enabled or the resulting build won't be able to connect to pipewire daemon
        -Dsupport=enabled # This one must be enabled or the resulting build won't be able to connect to pipewire daemon
        -Dsystemd-system-service=disabled
        -Dsystemd-system-unit-dir=disabled
        -Dsystemd-user-service=disabled
        -Dsystemd-user-unit-dir=disabled
        -Dsystemd=disabled
        -Dtest=disabled
        -Dtests=disabled
        -Dudev=disabled
        -Dudevrulesdir=disabled
        -Dv4l2=disabled
        -Dvideoconvert=disabled
        -Dvideotestsrc=disabled
        -Dvolume=disabled
        -Dvulkan=disabled
        -Dx11-xfixes=disabled
        -Dx11=disabled
        -Dsession-managers=[]
)
vcpkg_install_meson()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()
