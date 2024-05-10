# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/pfr
    REF boost-${VERSION}
    SHA512 d4b880be465bf37a3a1502dd3bea69e68f40fef94de55af5f5fdc30cf1b239b25e7558437977fbd8ea19e2473cb5cf4d7ee82138f765a8e14ae9674ece8454cf
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
