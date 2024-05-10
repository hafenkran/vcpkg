# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/asio
    REF boost-${VERSION}
    SHA512 2b5072ab187ac03a0addf78b62f15d31a6d7e59336784611d1db78359c287417d8c285f569f2f45c70dd66a14b2ea69880c8f2cbec6f157db119e94693e0f555
    HEAD_REF master
    PATCHES
        windows_alloca_header.patch
        opt-dep.diff
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
