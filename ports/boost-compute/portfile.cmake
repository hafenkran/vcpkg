# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compute
    REF boost-${VERSION}
    SHA512 6fe8801b1fb8e37b5182f784e1c2938a9039f63770d58310df9a76eb7dcb0d9f1a93e31b4a69346f59273e59c2cff3ae0cf32f9a3c2e95364c70d77615bce731
    HEAD_REF master
    PATCHES
        opt-filesystem.diff
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
